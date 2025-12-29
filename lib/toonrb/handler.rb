# frozen_string_literal: true

module Toonrb
  class Handler
    def initialize
      @stack = [Nodes::Root.new]
    end

    def output
      @stack.first
    end

    def push_array(array)
      current.push_value(array)
      @stack << array
    end

    def push_keyed_array(key, array)
      push_object_value(key, array)
      @stack << array
    end

    def push_array_value(value)
      @stack.pop if value.depth < current.depth
      current.push_value(value)
    end

    def push_object_value(key, value)
      if key.depth > current.depth
        new_object = Nodes::Object.new(key)
        if key.depth.zero?
          # Push new object to root object
          push_array_value(new_object)
        end
        @stack.push(new_object)
      elsif key.depth < current.depth
        @stack.pop
      end

      current.push_value(key, value)
    end

    private

    def current
      @stack.last
    end
  end
end
