# frozen_string_literal: true

module Toonrb
  module Nodes
    class Object
      def push_value(value, key: false)
        if key
          (@keys ||= []) << value
        else
          (@values ||= []) << value
        end
      end

      def to_ruby
        @keys
          .zip(@values || [])
          .to_h { |k, v| (v && [k.to_ruby, v.to_ruby]) || [k.to_ruby, {}] }
      end
    end

    class EmptyObject
      def to_ruby
        {}
      end
    end
  end
end
