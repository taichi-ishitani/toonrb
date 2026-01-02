# frozen_string_literal: true

module Toonrb
  module Nodes
    class Array < Base
      def initialize(size, position)
        super(position)
        @size = size
      end

      attr_reader :position

      def push_value(value, tabular_field: false, tabular_value: false, head_value: false)
        if tabular_field
          (@fields ||= []) << value
        elsif tabular_value
          (@values ||= []) << [] if head_value
          @values.last << value
        else
          (@values ||= []) << value
        end
      end

      def to_ruby
        if @fields
          fields = values_to_ruby(@fields)
          @values
            .map { |row| fields.zip(values_to_ruby(row)).to_h }
        else
          values_to_ruby(@values) || []
        end
      end

      private

      def values_to_ruby(values)
        values&.map(&:to_ruby)
      end
    end
  end
end
