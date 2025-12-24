# frozen_string_literal: true

module Toonrb
  class Handler
    def initialize
      @output = Nodes::Root.new
      @current = @output
    end

    attr_reader :output

    def push_child(node)
      @current.children.push(node)
    end
  end
end
