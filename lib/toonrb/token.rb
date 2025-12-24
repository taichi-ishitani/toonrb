# frozen_string_literal: true

module Toonrb
  class Position
    def initialize(filename, line, column)
      @filename = filename
      @line = line
      @column = column
    end

    attr_reader :filename
    attr_reader :line
    attr_reader :column
  end

  class Token
    def initialize(text, kind, position)
      @text = text
      @kind = kind
      @position = position
    end

    attr_reader :text
    attr_reader :kind
    attr_reader :position
  end
end
