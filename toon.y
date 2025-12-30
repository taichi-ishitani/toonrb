class Toonrb::GeneratedParser
token
  L_BRACKET
  R_BRACKET
  COLON
  DELIMITER
  QUOTED_STRING
  UNQUOTED_STRING
  BOOLEAN
  NULL
  NUMBER
  NEWLINE
  EOS

rule
  root
    :
    | root value
    | root eol
    ;

  value
    : object
    | array
    | primitive eol {
        handler.push_value(val[0])
      }
    ;

  object
    : object_item
    | object object_item
  object_item
    : object_key COLON eol
    | object_key COLON value
    | object_key array
    ;
  object_key
    : string {
        handler.push_object_key(val[0])
      }
    ;

  array
    : array_header inline_array_values eol {
        scanner.clear_delimiter
      }
  array_header
    : L_BRACKET number delimiter R_BRACKET COLON {
        array = Nodes::Array.new(val[0], val[1])
        handler.push_array(array)
      }
  delimiter
    : {
        scanner.default_delimiter
      }
    | DELIMITER {
        scanner.delimiter(val[0])
      }
    ;
  inline_array_values
    :
    | primitive {
        handler.push_value(val[0])
      }
    | inline_array_values DELIMITER primitive {
        handler.push_value(val[2])
      }
    ;

  primitive
    : string
    | boolean
    | null
    | number
    ;
  string
    : QUOTED_STRING {
        result = Toonrb::Nodes::QuotedString.new(val[0])
      }
    | UNQUOTED_STRING {
        result = Toonrb::Nodes::UnquotedString.new(val[0])
      }
    ;
  boolean
    : BOOLEAN {
        result = Toonrb::Nodes::Boolean.new(val[0])
      }
    ;
  null
    : NULL {
        result = Toonrb::Nodes::Null.new(val[0])
      }
    ;
  number
    : NUMBER {
        result = Toonrb::Nodes::Number.new(val[0])
      }
    ;

  eol
    : NEWLINE
    | EOS
    ;
