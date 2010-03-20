require "test_helper"
require "rack/test"
require "digest/md5"
require "fileutils"
require "tempfile"
require "shnotes"
require "shnotes/app"

module Shnotes
  class AppTest < Test::Unit::TestCase
    include Rack::Test::Methods

    NUM_NOTES_INITIALLY = 2

    def create_notes_file
      destination = @tempfile.path
      source = File.join(File.dirname(__FILE__), "/fixture/notes.pstore")
      FileUtils.cp source, destination
      destination
    end

    setup do
      @tempfile = Tempfile.new("notes_fixture.pstore")
      @notes = Shnotes::Notes.new(create_notes_file)
    end

    teardown do
      @tempfile.close(true)
    end

    def app
      app = Sinatra.new(App)
      App.notes = @notes
      app
    end

    should "have #{NUM_NOTES_INITIALLY} notes initially (test sanity check)" do
      assert_equal NUM_NOTES_INITIALLY, @notes.all_notes.size
    end

    context "for valid requests" do
      should "show all notes" do
        get "/"
        assert_equal @notes.all_notes.to_json, last_response.body
      end

      should "show a note" do
        get "/8f53a87af2f1207ab9b9aaaf354f9855"
        assert_equal "hopefully it isn't chris's blood".to_json, last_response.body
      end

      should "create a new note" do
        note = "noting your notes"
        expected_id = Digest::MD5.hexdigest(note)
        post "/", :note => note
        assert_equal({:id => expected_id, :note => note}.to_json, last_response.body)
        assert_equal NUM_NOTES_INITIALLY + 1, @notes.all_notes.size
      end

      should "strip whitespace around the note when creating a new note" do
        note = "  spacy  \t\n"
        expected_id = Digest::MD5.hexdigest(note.strip)
        post "/", :note => note
        assert_equal({:id => expected_id, :note => note.strip}.to_json, last_response.body)
        assert_equal NUM_NOTES_INITIALLY + 1, @notes.all_notes.size
      end

      should "remove a note" do
        delete "/8f53a87af2f1207ab9b9aaaf354f9855"
        assert_equal "hopefully it isn't chris's blood".to_json, last_response.body
        assert_equal NUM_NOTES_INITIALLY - 1, @notes.all_notes.size
      end
    end

    context "for invalid requests" do
      should "fail when requesting to show a non-existing note" do
        get "/deadbeef"
        assert_equal 404, last_response.status
      end

      should "fail when requesting to create a new note without the note" do
        post "/", {}
        assert_equal 400, last_response.status
      end

      should "fail when requesting to create a new note with empty note" do
        post "/", {:note => "  "}
        assert_equal 400, last_response.status
      end

      should "fail when requesting to remove a non-existing note" do
        delete "/deadbeef"
        assert_equal 404, last_response.status
      end
    end

    context "for caching behavior" do
      should "use etag for a note if HTTP_IF_NONE_MATCH is used in request" do
        get "/8f53a87af2f1207ab9b9aaaf354f9855", {}, {"HTTP_IF_NONE_MATCH" => '"8f53a87af2f1207ab9b9aaaf354f9855"'}
        assert_equal 304, last_response.status
        assert last_response.body.empty?
      end
    end
  end
end
