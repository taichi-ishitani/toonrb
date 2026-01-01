# frozen_string_literal: true

module Toonrb
  class Scanner
    INDENT = /^[ \t]*/

    NL = /\n/

    L_BRACKET = /\[ */

    R_BRACKET = /] */

    L_BRACE = /{ */

    R_BRACE = /} */

    COLON = /: */

    HYPHEN = /(?:- )|(?:-$)/

    D_QUOTE = /" */

    BACK_SLASH = /\\ */

    DELIMITER = /[,\t|] */

    BOOLEAN = /\A(?:true|false) *\Z/

    NULL = /\Anull *\Z/

    NUMBER = /\A-?(?:0|[1-9]\d*)(?:\.\d+)?(?:e[+-]?\d+)? *\Z/i

    def initialize(string, filename, indent_size)
      @ss = StringScanner.new(string)
      @filename = filename
      @line = 1
      @column = 1
      @delimiter = nil
      @indent_size = indent_size.to_f
      @indent_depth = 0
      @list_depth = []
      @reserved_tokens = []
    end

    def next_token
      scan_indent
      scan_eos
      if !@reserved_tokens.empty?
        @reserved_tokens.shift
      elsif (token = scan_token)
        [token.kind, token]
      end
    end

    def default_delimiter
      @delimiter = ','
    end

    def delimiter(token)
      @delimiter = token.text.strip
    end

    def clear_delimiter
      @delimiter = nil
    end

    private

    def scan_indent
      return if @column > 1 || eos?

      indent, _line, _column = scan(INDENT)
      return unless indent

      next_depth = (indent.size / @indent_size).floor
      update_indent_depth(next_depth)

      pop_list_stack(next_depth)
      if (hyphen_token = scan_list_hyphen)
        @reserved_tokens.push([hyphen_token.kind, hyphen_token])
      end
    end

    def pop_list_stack(indent_depth)
      @list_depth
        .delete_if { |depth| depth > indent_depth }
    end

    def scan_list_hyphen
      hyphen, line, column = scan(HYPHEN)
      return unless hyphen

      @indent_depth += 1
      @list_depth.push(@indent_depth)

      create_token(:HYPHEN, hyphen, line, column)
    end

    def update_indent_depth(next_depth)
      if @indent_depth > next_depth
        count = calc_indent_pop_count(next_depth)
        count.positive? &&
          count.times { @reserved_tokens.push([:POP_INDENT, nil]) }
      elsif next_depth > @indent_depth
        count = next_depth - @indent_depth
        count.positive? &&
          count.times { @reserved_tokens.push([:PUSH_INDENT, nil]) }
      end

      @indent_depth = next_depth
    end

    def calc_indent_pop_count(next_depth)
      count = @indent_depth - next_depth
      count -= @list_depth.count { |depth| next_depth < depth }
      count
    end

    def scan_eos
      return unless eos?

      update_indent_depth(0)
      @reserved_tokens.push([:EOS, nil])
      @reserved_tokens.push(nil)
    end

    def scan_token
      return if eos?

      token = scan_newline
      return token if token

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

    def scan_newline
      char, line, column = scan(NL)
      return unless char

      @line += 1
      @column = 1

      create_token(:NL, char, line, column)
    end

    def scan_header_symbol
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

      [L_BRACKET, R_BRACKET, L_BRACE, R_BRACE, COLON, D_QUOTE, BACK_SLASH]
        .none? { |symbol| symbol.match?(char) }
    end

    def create_token(kind, text, line, column)
      position = Position.new(@filename, line, column)
      Token.new(text, kind, @indent_depth, position)
    end
  end
end
