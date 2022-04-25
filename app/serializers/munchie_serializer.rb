class MunchieSerializer

  def self.format_data(destination, forecast, restaurant)
    {
      "data": {
        "id": "null",
        "type": "munchie",
        "attributes": {
          "destination_city": destination.city,
          "travel_time": destination.travel_time,
          "forecast": {
            "summary": forecast.description,
            "temperature": forecast.temperature.to_s
          },
          "restaurant": {
            "name": restaurant.name,
            "address": restaurant.address
          }
        }
      }
    }
  end
end
