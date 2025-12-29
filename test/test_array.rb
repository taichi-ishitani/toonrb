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
  end
end
