# frozen_string_literal: true

module Toonrb
  module Nodes
    class Object < Node
      def initialize(head_token)
        super
        @values = []
      end

      def push_value(key, value)
        @values << [key, value]
      end

      def to_ruby
        @values.to_h { |key_value| key_value.map(&:to_ruby) }
      end
    end
  end
end
