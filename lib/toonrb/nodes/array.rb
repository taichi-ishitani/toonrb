# frozen_string_literal: true

module Toonrb
  module Nodes
    class Array < Node
      def initialize(head_token, size)
        super(head_token)
        @size = size
        @values = []
      end

      def push_value(value)
        @values << value
      end

      def to_ruby
        @values&.map(&:to_ruby) || []
      end
    end
  end
end
