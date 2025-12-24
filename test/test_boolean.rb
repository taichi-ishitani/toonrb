# frozen_string_literal: true

require_relative 'test_helper'

module Toonrb
  class TestBoolean < TestCase
    def test_true
      assert_equal(load_json('true'), load_toon('true'))
    end

    def test_false
      assert_equal(load_json('false'), load_toon('false'))
    end
  end
end
