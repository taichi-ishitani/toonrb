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

      def validate
        if @fields
          validate_tabular_array
        else
          validate_array
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

      def validate_tabular_array
        validate_array_size('tabular rows')
        validate_tabular_row_size
        @valus&.flatten&.each(&:validate)
      end

      def validate_array
        validate_array_size('array items')
        @values&.each(&:validate)
      end

      def validate_array_size(item_kind)
        actual = @values&.size || 0
        expected = @size.to_ruby
        return if actual == expected

        raise_parse_error "expected #{expected} #{item_kind}, but got #{actual}", position
      end

      def validate_tabular_row_size
        expected = @fields.size
        @values.each do |row|
          actual = row.size
          next if actual == expected

          position = row.first.position
          raise_parse_error "expected #{expected} tabular row items, but got #{actual}", position
        end
      end

      def values_to_ruby(values)
        values&.map(&:to_ruby)
      end
    end
  end
end
