# frozen_string_literal: true

require_relative 'test_helper'

module Toonrb
  class TestToonrb < TestCase
    def test_symbolize_names
      toon = <<~'TOON'
        context:
          task: Our favorite hikes together
          location: Boulder
          season: spring_2025
        friends[3]: ana,luis,sam
        hikes[3]{id,name,distanceKm,elevationGain,companion,wasSunny}:
          1,Blue Lake Trail,7.5,320,ana,true
          2,Ridge Overlook,9.2,540,luis,false
          3,Wildflower Loop,5.1,180,sam,true
      TOON
      json = <<~'JSON'
        {
          "context": {
            "task": "Our favorite hikes together",
            "location": "Boulder",
            "season": "spring_2025"
          },
          "friends": ["ana", "luis", "sam"],
          "hikes": [
            {
              "id": 1,
              "name": "Blue Lake Trail",
              "distanceKm": 7.5,
              "elevationGain": 320,
              "companion": "ana",
              "wasSunny": true
            },
            {
              "id": 2,
              "name": "Ridge Overlook",
              "distanceKm": 9.2,
              "elevationGain": 540,
              "companion": "luis",
              "wasSunny": false
            },
            {
              "id": 3,
              "name": "Wildflower Loop",
              "distanceKm": 5.1,
              "elevationGain": 180,
              "companion": "sam",
              "wasSunny": true
            }
          ]
        }
      JSON
      assert_equal(load_json(json, symbolize_names: true), decode_toon(toon, symbolize_names: true))
    end
  end
end
