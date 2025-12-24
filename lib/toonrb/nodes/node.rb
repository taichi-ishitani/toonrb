# frozen_string_literal: true

module Toonrb
  module Nodes
    class Node
      def initialize
        @children = []
      end

      attr_reader :children
    end
  end
end
