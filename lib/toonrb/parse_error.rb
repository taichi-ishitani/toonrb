# frozen_string_literal: true

module Toonrb
  class ParseError < StandardError
    def initialize(error_message, position)
      super(error_message)
      @error_message = error_message
      @position = position
    end

    attr_reader :error_message
    attr_reader :position

    def to_s
      (position && "#{super} -- #{position}") || super
    end
  end

  module RaiseParseError
    private

    def raise_parse_error(message, position = nil)
      raise ParseError.new(message, position)
    end
  end
end
