# frozen_string_literal: true

module Toonrb
  module Nodes
    class Object < Node
      def initialize(head_token)
        super
        @values = []
      end

      def push_value(value)
        @values << value
      end

      def to_ruby
        @values
          .each_slice(2)
          .to_h { |k, v| (v && [k.to_ruby, v.to_ruby]) || [k.to_ruby, {}] }
      end
    end
  end
end
