class RoadTripSerializer

  def self.format_data(road_trip)
    {
      "data": {
        "id": "null",
        "type": "roadtrip",
        "attributes": {
          "start_city": road_trip.start_city,
          "end_city": road_trip.end_city,
          "travel_time": road_trip.travel_time,
          "weather_at_eta": {
            "temperature": road_trip.end_temp,
            "conditions": road_trip.end_conditions
          }
        }
      }
    }
  end

  def self.impossible_route(start, finish)
    {
      "data": {
        "id": "null",
        "type": "roadtrip",
        "attributes": {
          "start_city": start,
          "end_city": finish,
          "travel_time": "impossible",
          "weather_at_eta": {
          }
        }
      }
    }
  end
end
