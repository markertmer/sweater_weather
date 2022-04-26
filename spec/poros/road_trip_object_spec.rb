require 'rails_helper'

RSpec.describe ForecastObject, type: :poro do

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

  it 'has road trip data' do
    expect(@road_trip.start_city).to eq "Denver, CO"
    expect(@road_trip.end_city).to eq "Ft Collins, CO"
    expect(@road_trip.travel_time).to eq "1 hours 4 minutes"
    expect(@road_trip.end_temp).to eq 50
    expect(@road_trip.end_conditions).to eq "overcast clouds"
  end
end
