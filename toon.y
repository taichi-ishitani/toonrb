class Toonrb::GeneratedParser
token BOOLEAN NULL NUMBER

rule
  root_objects
    |
    | root_objects root_object
    ;
  root_object
    | primitive {
        @handler.push_child(val[0])
      }
    ;
  primitive
    | BOOLEAN {
        result = Toonrb::Nodes::Boolean.new(val[0])
      }
    | NULL {
        result = Toonrb::Nodes::Null.new(val[0])
      }
    | NUMBER {
        result = Toonrb::Nodes::Number.new(val[0])
      }
    ;
