require "test_helper"
require "shnotes/notes"
require "shnotes/notes/pstore"
require "shnotes/notes/redis"

module Shnotes
  class NotesTest < Test::Unit::TestCase
    should "raise error if unknown database type" do
      assert_raise(ArgumentError) { Shnotes::Notes.init_db(:no_such_db) }
    end

    {
      :pstore => {
        :type      => Shnotes::Notes::PStore,
        :init_args => [Tempfile.new("test_notes.pstore").path]
      },
      :redis  => {
        :type      => Shnotes::Notes::Redis,
        :init_args => [{:db => 1}]
      }
    }.each do |db_type, spec|
      context "for #{spec[:type]} instance" do
        setup do
          @notes = Shnotes::Notes.init_db(db_type, *spec[:init_args])
        end

        teardown do
          @notes.clear
        end

        should "create proper instance" do
          assert_equal spec[:type], @notes.class
        end

        context "with no content" do
          should "contain empty hash" do
            assert_equal({}, @notes.all)
          end

          should "store a note" do
            assert_nil @notes["1"]
            assert_equal "foo", @notes["1"] = "foo"
            assert_equal "foo", @notes["1"]
            assert_equal({"1" => "foo"}, @notes.all)
          end
        end

        context "with content" do
          setup do
            @notes["1"] = "bar"
            @notes["2"] = "zag"
          end

          should "have proper contents" do
            assert_equal({"1" => "bar", "2" => "zag"}, @notes.all)
          end

          should "delete a note" do
            assert_equal "bar", @notes.delete("1")
            assert_equal({"2" => "zag"}, @notes.all)
          end

          should "replace a note" do
            assert_equal "zomg", @notes["1"] = "zomg"
            assert_equal "zomg", @notes["1"]
          end

          should "clear all notes" do
            assert_equal({}, @notes.clear)
            assert_equal({}, @notes.all)
          end
        end
      end
    end
  end
end
