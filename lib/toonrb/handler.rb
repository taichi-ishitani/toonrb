# frozen_string_literal: true

module Toonrb
  class Handler
    def initialize
      @stack = [Nodes::Root.new]
    end

    def output
      @stack.first
    end

    def push_object_key(key)
      if key.depth > current.depth
        object = Nodes::Object.new(key)
        push_value(object)
        @stack << object
      end

      push_value(key, key: true)
    end

    def push_array(array)
      push_value(array)
      @stack << array
    end

    def push_value(value, **optargs)
      @stack.pop if value.depth < current.depth

      current.push_value(value, **optargs)
    end

    private

    def current
      @stack.last
    end
  end
end
