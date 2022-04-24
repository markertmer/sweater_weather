class ForecastService < ApplicationService

  def self.get_forecast(lat, lon)
    url = build_url(lat, lon)
    get_data(url)
  end

  def self.build_url(lat, lon)
    base = 'https://api.openweathermap.org/data/2.5/onecall?'
    location = "lat=#{lat}&lon=#{lon}&"
    options = 'exclude=minutely&units=imperial&'
    key = "appid=#{ENV['openweather_key']}"

    [base, location, options, key].join
  end
end
