class RoadTripObject

  attr_reader :start_city,
              :end_city,
              :travel_time,
              :end_temp,
              :end_conditions

  def initialize(hourly_forecast, destination)
    @start_city = destination.start_city
    @end_city = destination.city
    @travel_time = destination.travel_time

    find_end_weather(destination.travel_minutes, hourly_forecast)
  end

  def find_end_weather(travel_minutes, hourly_forecast)
    arrival_hour = (travel_minutes.to_f / 60).round
    end_weather = hourly_forecast[arrival_hour]

    @end_temp = end_weather.temperature
    @end_conditions = end_weather.description
  end
end
