# frozen_string_literal: true

module Toonrb
  module Nodes
    class Root < Node
      def to_ruby
        children.first&.to_ruby
      end
    end
  end
end
