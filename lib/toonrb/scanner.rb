# frozen_string_literal: true

module Toonrb
  class Scanner
    BOOLEAN = /true|false/

    NULL = /null/

    NUMBER = /-?(:?0|[1-9]\d*)(:?\.\d+)?(:?e[+-]?\d+)?/i

    def initialize(string, filename)
      @ss = StringScanner.new(string)
      @filename = filename
      @line = 1
      @column = 1
    end

    def next_token
      token = scan_token
      return [false, nil] unless token

      [token.kind, token]
    end

    private

    def scan_token
      return if eos?

      case
      when (text, line, column = scan(BOOLEAN))
        create_token(:BOOLEAN, text, line, column)
      when (text, line, column = scan(NULL))
        create_token(:NULL, text, line, column)
      when (text, line, column = scan(NUMBER))
        create_token(:NUMBER, text, line, column)
      end
    end

    def eos?
      @ss.eos?
    end

    def scan(pattern)
      text = @ss.scan(pattern)
      return unless text

      line = @line
      column = @column

      update_state(text)

      [text, line, column]
    end

    def update_state(text)
      @column += text.length
    end

    def create_token(kind, text, line, column)
      position = Position.new(@filename, line, column)
      Token.new(text, kind, position)
    end
  end
end
