class MunchieFacade

  def self.get_munchie(start, finish, food)
    data = DestinationService.get_destination(start, finish)
    destination = DestinationObject.new(data[:route])

    data = LocationService.get_location(destination.city)
    location = LocationObject.new(data[:results][0][:locations][0])

    data = ForecastService.get_forecast(location.latitude, location.longitude)
    forecast = ForecastObject.new(data)

    data = RestaurantService.get_restaurant(destination.city, food)
    restaurant = RestaurantObject.new(data[:businesses][0])

    MunchieSerializer.format_data(destination, forecast, restaurant)
  end
end
