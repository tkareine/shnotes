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
          assert_equal({}, @notes.all)
        end

        should "store a note" do
          assert_nil @notes[1]
          assert_equal "foo", @notes[1] = "foo"
          assert_equal "foo", @notes[1]
          assert_equal({1 => "foo"}, @notes.all)
        end
      end

      context "with content" do
        setup do
          @notes = Shnotes::Notes::PStore.new(@temp_file.path)
          @notes[1] = "bar"
          @notes[2] = "zag"
        end

        should "have proper contents" do
          assert_equal({1 => "bar", 2 => "zag"}, @notes.all)
        end

        should "delete a note" do
          assert_equal "bar", @notes.delete(1)
          assert_equal({2 => "zag"}, @notes.all)
        end

        should "replace a note" do
          assert_equal "zomg", @notes[1] = "zomg"
          assert_equal "zomg", @notes[1]
        end

        should "clear all notes" do
          assert_equal({}, @notes.clear)
          assert_equal({}, @notes.all)
        end
      end
    end
  end
end