# frozen_string_literal: true

module Toonrb
  module Nodes
    class Root < Array
      def initialize
        super(nil, nil)
      end

      def to_ruby
        @values.first&.to_ruby
      end
    end
  end
end
