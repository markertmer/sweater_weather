require 'rails_helper'

RSpec.describe ForecastObject, type: :poro do

  before do
    response_body = File.read("spec/fixtures/forecasts/good_request_response.json")
    body = JSON.parse(response_body, symbolize_names: true)

    @forecast = ForecastObject.new(body)
  end

  it 'has current weather data' do
    # current = @forecast.current_data

    expect(@forecast.date).to eq "April 23"
    expect(@forecast.description).to eq "overcast clouds"
    expect(@forecast.feels_like_temp).to eq 44
    expect(@forecast.high_temp).to eq 55
    expect(@forecast.humidity).to eq 33
    expect(@forecast.icon_url).to eq "http://openweathermap.org/img/wn/04d@2x.png"
    expect(@forecast.low_temp).to eq 45
    expect(@forecast.sunrise).to eq "6:09 AM"
    expect(@forecast.sunset).to eq "7:47 PM"
    expect(@forecast.temperature).to eq 50
    expect(@forecast.time).to eq "7:38 PM"
    expect(@forecast.uv_index).to eq 0
    expect(@forecast.uv_description).to eq "low"
    expect(@forecast.visibility).to eq 6.2
  end

  it 'has hourly weather data' do
    hourly = @forecast.hours

    expect(hourly).to be_an Array
    expect(hourly.count).to eq 48

    hourly.each do |hour|
      expect(hour).to be_instance_of HourObject
      expect(hour.icon_url).to be_a String
      expect(hour.temperature).to be_an Integer
      expect(hour.time).to be_a String
    end

    first = hourly[0]

    expect(first.icon_url).to eq "http://openweathermap.org/img/wn/04d@2x.png"
    expect(first.temperature).to eq 50
    expect(first.time).to eq "7:00 PM"
  end

  it 'has daily weather data' do
    daily = @forecast.days

    expect(daily).to be_an Array
    expect(daily.count).to eq 8

    daily.each do |day|
      expect(day).to be_instance_of DayObject
      expect(day.description).to be_a String
      expect(day.high_temp).to be_an Integer
      expect(day.icon_url).to be_a String
      expect(day.low_temp).to be_an Integer
      expect(day.name).to be_a String
      expect(day.precip_amount).to be_an Float
      expect(day.precip_chance).to be_an Integer
    end

    first = daily[0]

    expect(first.description).to eq "light rain"
    expect(first.high_temp).to eq 55
    expect(first.icon_url).to eq "http://openweathermap.org/img/wn/10d@2x.png"
    expect(first.low_temp).to eq 45
    expect(first.name).to eq "Saturday"
    expect(first.precip_amount).to eq 0.14
    expect(first.precip_chance).to eq 39
  end
end
