class Toonrb::GeneratedParser
token BOOLEAN

rule
  root_objects
    |
    | root_objects root_object
    ;
  root_object
    | primitive { @handler.push_child(val[0]) }
    ;
  primitive
    | BOOLEAN { result = Toonrb::Nodes::Boolean.new(val[0]) }
    ;
