require "test_helper"
require "tempfile"
require "shnotes/notes"

module Shnotes
  class NotesTest < Test::Unit::TestCase
    include Shnotes

    setup do
      @test_file = Tempfile.new("test_notes.pstore")
      Notes.store_location = @test_file.path
    end

    teardown do
      @test_file.close(true)
    end

    context "with no content" do
      should "contain empty hash" do
        assert_equal({}, Notes.notes)
      end

      should "store a note" do
        assert_equal "foo", Notes.put_note(1, "foo")
        assert_equal({1 => "foo"}, Notes.notes)
      end

      should "clear all notes" do
        # we must test clearing all notes here since the next context depends
        # on it
        Notes.put_note(3, "zap")
        assert_equal({3 => "zap"}, Notes.notes)
        assert_equal({}, Notes.clear_notes)
        assert_equal({}, Notes.notes)
      end
    end

    context "with content" do
      setup do
        Notes.put_note(1, "bar")
        Notes.put_note(2, "zag")
      end

      teardown do
        Notes.clear_notes
      end

      should "have proper contents" do
        assert_equal({1 => "bar", 2 => "zag"}, Notes.notes)
      end

      should "delete a note" do
        assert_equal "bar", Notes.delete_note(1)
        assert_equal({2 => "zag"}, Notes.notes)
      end
    end
  end
end
