# frozen_string_literal: true

module Toonrb
  module Nodes
    class Base
      def initialize(position)
        @position = position
      end

      attr_reader :position
    end
  end
end
