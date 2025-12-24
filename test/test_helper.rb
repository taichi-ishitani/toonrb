# frozen_string_literal: true

require_relative '../lib/toonrb'
require 'minitest/autorun'
require 'json'

module Toonrb
  class TestCase < Minitest::Test
    private

    def load_toon(toon)
      Toonrb.load(toon)
    end

    def load_json(json)
      JSON.load(json)
    end
  end
end
