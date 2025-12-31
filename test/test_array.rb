# frozen_string_literal: true

require_relative 'test_helper'

module Toonrb
  class TestArray < TestCase
    def test_array_nested
      toon = '[5]: x,y,"true",true,10'
      json = '["x", "y", "true", true, 10]'
      assert_equal(load_json(json), load_toon(toon))

      # TODO
      #toon = <<~'TOON'
      #  [2]{id}:
      #    1
      #    2
      #TOON
      #json = '[{"id": 1}, {"id": 2}]'
      #assert_equal(load_json(json), load_toon(toon))

      # TODO
      #toon = <<~'TOON'
      #  [2]:
      #    - id: 1
      #    - id: 2
      #      name: Ada
      #TOON
      #json = '[{"id": 1}, {"id" 2, "name": "Ada"}]'
      #assert_equal(load_json(json), load_toon(toon))

      toon = '[0]:'
      json = '[]'
      assert_equal(load_json(json), load_toon(toon))

      #toon = <<~'TOON'
      #[2]:
      #  - [2]: 1, 2
      #  - [0]:
      #TOON
      #json = '[[1, 2], []]'
      #assert_equal(load_json(json), load_toon(toon))
    end

    def test_array_primitive
      toon = 'tags[3]: reading,gaming,coding'
      json = '{"tags":["reading","gaming","coding"]}'
      assert_equal(load_json(json), load_toon(toon))

      toon = 'nums[3]: 1,2,3'
      json = '{"nums":[1,2,3]}'
      assert_equal(load_json(json), load_toon(toon))

      toon = 'data[4]: x,y,true,10'
      json = '{"data":["x","y",true,10]}'
      assert_equal(load_json(json), load_toon(toon))

      toon = 'items[0]:'
      json = '{"items":[]}'
      assert_equal(load_json(json), load_toon(toon))

      toon = 'items[1]: ""'
      json = '{"items":[""]}'
      assert_equal(load_json(json), load_toon(toon))

      toon = 'items[3]: a,"",b'
      json = '{"items":["a","","b"]}'
      assert_equal(load_json(json), load_toon(toon))

      toon = 'items[2]: " ","  "'
      json = '{"items":[" ","  "]}'
      assert_equal(load_json(json), load_toon(toon))

      toon = 'items[3]: a,"b,c","d:e"'
      json = '{"items":["a","b,c","d:e"]}'
      assert_equal(load_json(json), load_toon(toon))

      toon = 'items[4]: x,"true","42","-3.14"'
      json = '{"items":["x","true","42","-3.14"]}'
      assert_equal(load_json(json), load_toon(toon))

      toon = 'items[3]: "[5]","- item","{key}"'
      json = '{"items":["[5]","- item","{key}"]}'
      assert_equal(load_json(json), load_toon(toon))

      toon = '"my-key"[3]: 1,2,3'
      json = '{"my-key":[1,2,3]}'
      assert_equal(load_json(json), load_toon(toon))

      toon = '"key[test]"[3]: 1,2,3'
      json = '{"key[test]":[1,2,3]}'
      assert_equal(load_json(json), load_toon(toon))

      # TODO
      # Need to clarify specification of unquoted array key format
      # https://github.com/toon-format/spec/discussions/25
      #toon = 'key[test][3]: 1,2,3'
      #json = '{"key[test][3]":"1,2,3"}'
      #assert_equal(load_json(json), load_toon(toon))

      toon = '"x-custom"[0]:'
      json = '{"x-custom":[]}'
      assert_equal(load_json(json), load_toon(toon))
    end

    def test_array_tabular
      toon = <<~'TOON'
        items[2]{sku,qty,price}:
          A1,2,9.99
          B2,1,14.5
      TOON
      json = <<~'JSON'
        {"items":[{"sku":"A1","qty":2,"price":9.99},{"sku":"B2","qty":1,"price":14.5}]}
      JSON
      assert_equal(load_json(json), load_toon(toon))

      toon = <<~'TOON'
        items[2]{id,value}:
          1,null
          2,"test"
      TOON
      json = <<~'JSON'
        {"items":[{"id":1,"value":null},{"id":2,"value":"test"}]}
      JSON
      assert_equal(load_json(json), load_toon(toon))

      toon = <<~'TOON'
        items[2]{id,note}:
          1,"a:b"
          2,"c:d"
      TOON
      json = <<~'JSON'
        {"items":[{"id":1,"note":"a:b"},{"id":2,"note":"c:d"}]}
      JSON
      assert_equal(load_json(json), load_toon(toon))

      toon = <<~'TOON'
        items[2]{"order:id","full name"}:
          1,Ada
          2,Bob
      TOON
      json = <<~'JSON'
        {"items":[{"order:id":1,"full name":"Ada"},{"order:id":2,"full name":"Bob"}]}
      JSON
      assert_equal(load_json(json), load_toon(toon))

      toon = <<~'TOON'
        "x-items"[2]{id,name}:
          1,Ada
          2,Bob
      TOON
      json = <<~'JSON'
        {"x-items":[{"id":1,"name":"Ada"},{"id":2,"name":"Bob"}]}
      JSON
      assert_equal(load_json(json), load_toon(toon))

      # TODO
      #toon = <<~'TOON'
      #  items[2]{id,name}:
      #    1,Alice
      #    2,Bob
      #  count: 2
      #TOON
      #json = <<~'JSON'
      #  {"items":[{"id":1,"name":"Alice"},{"id":2,"name":"Bob"}],"count":2}
      #JSON
      #assert_equal(load_json(json), load_toon(toon))
    end
  end
end
