class Toonrb::GeneratedParser
token
  L_BRACKET
  R_BRACKET
  L_BRACE
  R_BRACE
  COLON
  HYPHEN
  DELIMITER
  QUOTED_STRING
  UNQUOTED_STRING
  BOOLEAN
  NULL
  NUMBER
  NL
  PUSH_INDENT
  POP_INDENT
  EOS

rule
  root
    :
    | root object
    | root array
    | root primitive eol {
        handler.push_value(val[1])
      }
    | root eol

  object
    : object_head_item object_item* {
        handler.pop
      }
  object_nested
    : PUSH_INDENT object_head_item object_item* POP_INDENT {
        handler.pop
      }
  object_head_item
    : object_head_key COLON eol
    | object_head_key COLON primitive eol {
        handler.push_value(val[2])
      }
    | object_head_key array
    | object_head_key COLON array
    | object_head_key COLON eol object_nested
  object_head_key
    : string {
        handler.push_object(val[0])
      }
  object_item
    : object_key COLON eol
    | object_key COLON primitive eol {
        handler.push_value(val[2])
      }
    | object_key array
    | object_key COLON array
    | object_key COLON eol object_nested
  object_key
    : string {
        handler.push_value(val[0], key: true)
      }

  array
    : array_header eol {
        handler.pop
        scanner.clear_delimiter
      }
    | array_header inline_array_values eol {
        handler.pop
        scanner.clear_delimiter
      }
    | array_header eol PUSH_INDENT list_array_values POP_INDENT {
        handler.pop
        scanner.clear_delimiter
      }
    | tebular_array_header eol {
        handler.pop
        scanner.clear_delimiter
      }
    | tebular_array_header eol PUSH_INDENT tabular_rows POP_INDENT {
        handler.pop
        scanner.clear_delimiter
      }
  array_header
    : array_header_common COLON
  tebular_array_header
    : array_header_common L_BRACE tabular_fields R_BRACE COLON
  array_header_common
    : L_BRACKET number delimiter R_BRACKET {
        handler.push_array(val[1])
      }
  delimiter
    : {
        scanner.default_delimiter
      }
    | DELIMITER {
        scanner.delimiter(val[0])
      }
  tabular_fields
    : string (DELIMITER string)* {
        each_list_item(val) { |v, _| handler.push_value(v, tabular_field: true) }
      }
  inline_array_values
    : primitive (DELIMITER primitive)* {
        each_list_item(val) { |v, _| handler.push_value(v) }
      }
  list_array_values
    : list_array_value+
  list_array_value
    : HYPHEN eol {
        handler.push_empty_object
      }
    | HYPHEN primitive eol {
        handler.push_value(val[1])
      }
    | HYPHEN array
    | HYPHEN object
  tabular_rows
    : (tabular_row eol)+
  tabular_row
    : primitive (DELIMITER primitive)* {
        each_list_item(val) do |v, i|
          handler.push_value(v, tabular_value: true, head_value: i.zero?)
        end
      }

  primitive
    : string
    | boolean
    | null
    | number
  string
    : QUOTED_STRING {
        result = Toonrb::Nodes::QuotedString.new(val[0])
      }
    | UNQUOTED_STRING {
        result = Toonrb::Nodes::UnquotedString.new(val[0])
      }
  boolean
    : BOOLEAN {
        result = Toonrb::Nodes::Boolean.new(val[0])
      }
  null
    : NULL {
        result = Toonrb::Nodes::Null.new(val[0])
      }
  number
    : NUMBER {
        result = Toonrb::Nodes::Number.new(val[0])
      }

  eol
    : NL
    | EOS
