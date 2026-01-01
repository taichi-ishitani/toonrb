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

    def each_list_item(val, &)
      [val[0], *val[1]&.map { _2 }].each_with_index(&)
    end
  end
end
