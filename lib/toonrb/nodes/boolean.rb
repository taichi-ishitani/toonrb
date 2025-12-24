# frozen_string_literal: true

module Toonrb
  module Nodes
    class Boolean < Node
      def initialize(token)
        @token = token
        super()
      end

      attr_reader :token

      def to_ruby
        token.text == 'true'
      end
    end
  end
end
