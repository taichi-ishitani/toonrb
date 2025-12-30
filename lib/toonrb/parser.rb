# frozen_string_literal: true

module Toonrb
  class Parser < GeneratedParser
    def initialize(scanner, handler)
      @scanner = scanner
      @handler = handler
      super()
      #@yydebug = true
    end

    def parse
      do_parse
      handler.output
    end

    private

    attr_reader :scanner
    attr_reader :handler

    def next_token
      scanner.next_token
    end
  end
end
