# frozen_string_literal: true

module Toonrb
  class Parser < GeneratedParser
    def initialize(scanner)
      @scanner = scanner
      @handler = Handler.new
      super()
    end

    def parse
      do_parse
      @handler.output
    end

    private

    def next_token
      @scanner.next_token
    end
  end
end
