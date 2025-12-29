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
    | root root_item
    ;
  root_item
    : primitive_array
    | primitive_keyed_array
    | primitive eol {
        handler.push_array_value(val[0])
      }
    ;

  primitive_array
    : array_header primitive_array_values eol {
        scanner.end_array
      }
  primitive_keyed_array
    : keyed_array_header primitive_array_values eol {
        scanner.end_array
      }
  array_header
    : L_BRACKET number delimiter R_BRACKET COLON {
        array = Nodes::Array.new(val[0], val[1])
        handler.push_array(array)
        scanner.end_array_header
      }
  keyed_array_header
    : array_key L_BRACKET number delimiter R_BRACKET COLON {
        array = Nodes::Array.new(val[0], val[2])
        handler.push_keyed_array(val[0], array)
        scanner.end_array_header
      }
    ;
  array_key
    : quoted_string
    | unquoted_string
    ;
  delimiter
    : {
        scanner.default_delimiter
      }
    | DELIMITER {
        scanner.delimiter(val[0])
      }
    ;
  primitive_array_values
    :
    | primitive {
        handler.push_array_value(val[0])
      }
    | primitive_array_values DELIMITER primitive {
        handler.push_array_value(val[2])
      }
    ;

  primitive
    : quoted_string
    | unquoted_string
    | boolean
    | null
    | number
    ;
  quoted_string
    : QUOTED_STRING {
        result = Toonrb::Nodes::QuotedString.new(val[0])
      }
  unquoted_string
    : UNQUOTED_STRING {
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
