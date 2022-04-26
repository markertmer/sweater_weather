require 'rails_helper'

RSpec.describe RoadTripFacade, type: :facade do
  before do
    url = DestinationService.build_url('denver, co', 'fort collins, co')
    location_response = File.read('spec/fixtures/destinations/good_request_response.json')
    stub_request(:get, url).to_return(status: 200, body: location_response)

    url = LocationService.build_url('Ft Collins, CO')
    location_response = File.read('spec/fixtures/locations/good_request_response.json')
    stub_request(:get, url).to_return(status: 200, body: location_response)

    url = ForecastService.build_url('41.883229', '-87.632398')
    forecast_response = File.read('spec/fixtures/forecasts/good_request_response.json')
    stub_request(:get, url).to_return(status: 200, body: forecast_response)
  end

  it 'returns JSON data for location query' do
    output = RoadTripFacade.get_road_trip('denver, co', 'fort collins, co')

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
