require "test_helper"
require "tempfile"
require "shnotes/notes/pstore"

module Shnotes
  module Notes
    class PStoreTest < Test::Unit::TestCase
      setup do
        @temp_file = Tempfile.new("test_notes.pstore")
      end

      teardown do
        @temp_file.close(true)
      end

      context "with no content" do
        setup do
          @notes = Shnotes::Notes::PStore.new(@temp_file.path)
        end

        should "contain empty hash" do
          assert_equal({}, @notes.all_notes)
        end

        should "store a note" do
          assert_equal "foo", @notes.put_note(1, "foo")
          assert_equal({1 => "foo"}, @notes.all_notes)
        end
      end

      context "with content" do
        setup do
          @notes = Shnotes::Notes::PStore.new(@temp_file.path)
          @notes.put_note(1, "bar")
          @notes.put_note(2, "zag")
        end

        should "have proper contents" do
          assert_equal({1 => "bar", 2 => "zag"}, @notes.all_notes)
        end

        should "delete a note" do
          assert_equal "bar", @notes.delete_note(1)
          assert_equal({2 => "zag"}, @notes.all_notes)
        end

        should "clear all notes" do
          assert_equal({}, @notes.clear_notes)
          assert_equal({}, @notes.all_notes)
        end
      end
    end
  end
end
