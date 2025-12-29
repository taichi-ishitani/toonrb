# frozen_string_literal: true

module Toonrb
  class Scanner
    L_BRACKET = /\[ */

    R_BRACKET = /] */

    L_BRACE = /{ */

    R_BRACE = /} */

    COLON = /: */

    D_QUOTE = /" */

    BACK_SLASH = /\\ */

    DELIMITER = /[,\t|] */

    BOOLEAN = /\A(?:true|false) *\Z/

    NULL = /\Anull *\Z/

    NUMBER = /\A-?(?:0|[1-9]\d*)(?:\.\d+)?(?:e[+-]?\d+)? *\Z/i

    def initialize(string, filename)
      @ss = StringScanner.new(string)
      @filename = filename
      @line = 1
      @column = 1
      @indent_depth = 0
      end_array
    end

    def next_token
      token = scan_token
      return eos_token unless token

      [token.kind, token]
    end

    def default_delimiter
      @delimiter = ','
    end

    def delimiter(token)
      @delimiter = token.text.strip
    end

    def end_array_header
      @in_header = false
    end

    def end_array
      @delimiter = nil
      @in_header = true
    end

    private

    def scan_token
      return if eos?

      token = scan_header_symbol
      return token if token

      token = scna_delimiter
      return token if token

      token = scan_quoted_string
      return token if token

      scan_unquoted_string
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

    def scan_char
      char = @ss.getch
      return unless char

      update_state(char)
      char
    end

    def peek(pattern)
      @ss.check(pattern)
    end

    def advance(char)
      @ss.pos += char.bytesize
      update_state(char)
    end

    def update_state(text)
      @column += text.length
    end

    def scan_header_symbol
      return unless @in_header

      {
        L_BRACKET: L_BRACKET, R_BRACKET: R_BRACKET,
        L_BRACE: L_BRACE, R_BRACE: R_BRACE, COLON: COLON
      }.each do |kind, symbol|
        char, line, column = scan(symbol)
        next unless char

        token = create_token(kind, char, line, column)
        return token
      end

      nil
    end

    def scna_delimiter
      char, line, column = scan(DELIMITER)
      return unless char

      create_token(:DELIMITER, char, line, column)
    end

    def scan_quoted_string
      return unless peek(/"/)

      line = @line
      column = @column

      buffer = []
      while (char = scan_char)
        if char == '\\' && (escaped_char = scan_escaped_char)
          buffer << escaped_char
        else
          buffer << char
          break if buffer.size >= 2 && char == '"'
        end
      end

      if buffer.size < 2 || buffer.last != '"'
        # TODO
        # raise missing closing quote error
      end

      text = buffer.join
      create_token(:QUOTED_STRING, text, line, column)
    end

    def scan_escaped_char
      char = scan_char
      return unless char

      escaped_char =
        { '\\' => '\\', '"' => '"', 'n' => "\n", 'r' => "\r", 't' => "\t" }[char]
      return escaped_char if escaped_char

      # TODO
      # raise invalid escape sequence error
    end

    def scan_unquoted_string
      line = @line
      column = @column

      buffer = []
      while (char = peek(/./))
        break unless valid_unquoted_char?(char)

        advance(char)
        buffer << char
      end

      text = buffer.join.strip
      { BOOLEAN: BOOLEAN, NULL: NULL, NUMBER: NUMBER }.each do |kind, pattern|
        return create_token(kind, text, line, column) if pattern.match?(text)
      end

      create_token(:UNQUOTED_STRING, text, line, column)
    end

    def valid_unquoted_char?(char)
      return false if char == "\n" || (@delimiter && char == @delimiter)

      {
        L_BRACKET: L_BRACKET, R_BRACKET: R_BRACKET, L_BRACE: L_BRACE,
        R_BRACE: R_BRACE, COLON: COLON, D_QUOTE: D_QUOTE, BACK_SLASH: BACK_SLASH
      }.each do |kind, symbol|
        next unless symbol.match?(char)

        if @in_header && [:L_BRACKET, :R_BRACKET, :L_BRACE, :R_BRACE, :COLON].any?(kind)
          return false
        end

        # TODO
        # raise invalid unquated char error
      end

      true
    end

    def create_token(kind, text, line, column)
      position = Position.new(@filename, line, column)
      Token.new(text, kind, @indent_depth, position)
    end

    def eos_token
      return if @eos_done

      @eos_done = true
      [:EOS, nil]
    end
  end
end
