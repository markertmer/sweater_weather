class ForecastService < ApplicationService
  class << self

    def get_forecast(lat, lon)
      get_response_body(url, forecast_params(lat, lon))
    end

    def url
      'https://api.openweathermap.org/data/2.5/onecall'
    end

    def forecast_params(lat, lon)
      {
        "lat": lat,
        "lon": lon,
        "exclude": "minutely",
        "units": "imperial",
        "appid": ENV['openweather_key']
      }
    end
  end
end
