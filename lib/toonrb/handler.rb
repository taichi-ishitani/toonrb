# frozen_string_literal: true

module Toonrb
  class Handler
    def initialize
      @stack = [Nodes::Root.new]
    end

    def output
      @stack.first
    end

    def push_object(key)
      object = Nodes::Object.new
      push_value(object)

      @stack << object
      push_value(key, key: true)
    end

    def push_array(size)
      array = Nodes::Array.new(size)
      push_value(array)

      @stack << array
    end

    def push_value(value, **optargs)
      current.push_value(value, **optargs)
    end

    def push_empty_object
      object = Nodes::EmptyObject.new
      push_value(object)
    end

    def pop
      @stack.pop
    end

    private

    def current
      @stack.last
    end
  end
end
