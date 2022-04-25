require 'rails_helper'

RSpec.describe MunchieSerializer, type: :serializer do
  before do
    response_body = File.read("spec/fixtures/destinations/good_request_response.json")
    body = JSON.parse(response_body, symbolize_names: true)
    data = body[:route]
    @destination = DestinationObject.new(data)

    response_body = File.read("spec/fixtures/forecasts/good_request_response.json")
    body = JSON.parse(response_body, symbolize_names: true)
    @forecast = ForecastObject.new(body)

    response_body = File.read("spec/fixtures/restaurants/good_request_response.json")
    body = JSON.parse(response_body, symbolize_names: true)
    top_result = body[:businesses][0]
    @restaurant = RestaurantObject.new(top_result)
  end

  it 'converts POROs to JSON' do
    output = MunchieSerializer.format_data(@destination, @forecast, @restaurant)

    data = output[:data]
    expect(data[:id]).to eq "null"
    expect(data[:type]).to eq "munchie"

    attributes = data[:attributes]
    expect(attributes[:destination_city]).to eq "Ft Collins, CO"
    expect(attributes[:travel_time]).to eq "1 hours 4 minutes"

    forecast = attributes[:forecast]
    expect(forecast[:summary]).to eq "overcast clouds"
    expect(forecast[:temperature]).to eq "50"

    restaurant = attributes[:restaurant]
    expect(restaurant[:name]).to eq "Big AL'S Burgers & Dogs"
    expect(restaurant[:address]).to eq "140 W Mountain Ave, Fort Collins, CO 80524"
  end
end
