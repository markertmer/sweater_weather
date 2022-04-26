class ForecastSerializer

  def self.format_data(forecast, location)
    {
      "data": {
        "id": "null",
        "type": "forecast",
        "attributes": {
          "location": {
            "city": location.city,
            "state": location.state,
            "country": location.country,
          },
          "current": {
            "date": forecast.date,
            "description": forecast.description,
            "feels_like_temp": forecast.feels_like_temp,
            "high_temp": forecast.high_temp,
            "humidity": forecast.humidity,
            "icon_url": forecast.icon_url,
            "low_temp": forecast.low_temp,
            "sunrise": forecast.sunrise,
            "sunset": forecast.sunset,
            "temperature": forecast.temperature,
            "time": forecast.time,
            "uv_index": forecast.uv_index,
            "uv_description": forecast.uv_description,
            "visibility": forecast.visibility,
          },
          "hourly":
            forecast.hours.map do |hour|
              {
              "time": hour.time,
              "temperature": hour.temperature,
              "icon_url": hour.icon_url
              }
            end,
          "daily":
            forecast.days.map do |day|
              {
              "name": day.name,
              "description": day.description,
              "high_temp": day.high_temp,
              "icon_url": day.icon_url,
              "low_temp": day.low_temp,
              "precip_amount": day.precip_amount,
              "precip_chance": day.precip_chance
              }
            end
          }
        }
      }
  end
end
