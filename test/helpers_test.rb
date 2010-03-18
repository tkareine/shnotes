require "test_helper"
require "shnotes/helpers"

module Shnotes
  class HelpersTest < Test::Unit::TestCase
    include Helpers

    context "for determining whether a value is blank" do
      test "nil is blank" do
        assert blank? nil
      end

      test "empty string is blank" do
        assert blank? ""
      end

      test "non-empty string is not blank" do
        assert !blank?("foo")
      end
    end
  end
end
