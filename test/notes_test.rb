require "test_helper"
require "shnotes/notes"

module Shnotes
  class NotesTest < Test::Unit::TestCase
    should "raise error if unknown database type" do
      assert_raise(ArgumentError) { Shnotes::Notes.init_db(:no_such_db) }
    end

    context "for PStore instance" do
      setup do
        @temp_file = Tempfile.new("test_notes.pstore")
      end

      teardown do
        @temp_file.close(true)
      end

      should "create instance" do
        notes = Shnotes::Notes.init_db(:pstore, @temp_file.path)
        assert_equal Shnotes::Notes::PStore, notes.class
      end
    end
  end
end
