# frozen_string_literal: true

module Toonrb
  class Parser < GeneratedParser
    def initialize(scanner, handler, debug: false)
      @scanner = scanner
      @handler = handler
      @yydebug = debug
      super()
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
