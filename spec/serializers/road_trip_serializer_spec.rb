require 'rails_helper'

RSpec.describe RoadTripSerializer, type: :serializer do
  before do
    response_body = File.read("spec/fixtures/forecasts/good_request_response.json")
    body = JSON.parse(response_body, symbolize_names: true)
    forecast = ForecastObject.new(body)

    response_body = File.read("spec/fixtures/destinations/good_request_response.json")
    body = JSON.parse(response_body, symbolize_names: true)
    data = body[:route]
    destination = DestinationObject.new(data)

    @road_trip = RoadTripObject.new(forecast.hours, destination)
  end

  it 'converts POROs to JSON' do
    output = RoadTripSerializer.format_data(@road_trip)

    data = output[:data]
    expect(data[:id]).to eq "null"
    expect(data[:type]).to eq "roadtrip"

    attributes = data[:attributes]
    expect(attributes[:start_city]).to eq "Denver, CO"
    expect(attributes[:end_city]).to eq "Ft Collins, CO"
    expect(attributes[:travel_time]).to eq "1 hours 4 minutes"

    weather = attributes[:weather_at_eta]
    expect(weather[:temperature]).to eq 50
    expect(weather[:conditions]).to eq "overcast clouds"
  end
end
