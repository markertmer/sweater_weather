class RoadTripFacade

  def self.get_road_trip(start, finish)
    data = DestinationService.get_destination(start, finish)

    if data[:route][:routeError][:errorCode] == 2
      RoadTripSerializer.impossible_route(start, finish)

    else
      destination = DestinationObject.new(data[:route])

      data = LocationService.get_location(destination.city)
      location = LocationObject.new(data[:results][0][:locations][0])

      data = ForecastService.get_forecast(location.latitude, location.longitude)
      forecast = ForecastObject.new(data)

      road_trip = RoadTripObject.new(forecast.hours, destination)

      RoadTripSerializer.format_data(road_trip)
    end
  end
end
