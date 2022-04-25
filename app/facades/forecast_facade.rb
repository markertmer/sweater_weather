class ForecastFacade

  def self.get_forecast(query)
    response = LocationService.get_location(query)

    if response[:info][:statuscode] == 400
      NoResultsSerializer.response
    else
      results = response[:results][0][:locations][0]
      location = LocationObject.new(results)

      response = ForecastService.get_forecast(location.latitude, location.longitude)
      forecast = ForecastObject.new(response)
      ForecastSerializer.format_data(forecast, location)
    end
  end
end
