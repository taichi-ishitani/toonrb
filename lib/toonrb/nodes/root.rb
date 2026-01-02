# frozen_string_literal: true

module Toonrb
  module Nodes
    class Root < Array
      def initialize
        super(nil, nil)
      end

      def validate
        @values.each_with_index do |value, i|
          i.positive? &&
            (raise_parse_error 'two or more values at root depth', value.position)
          value.validate
        end
      end

      def to_ruby
        @values.first&.to_ruby
      end
    end
  end
end
