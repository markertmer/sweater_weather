require 'rails_helper'

RSpec.describe MunchieFacade, type: :facade do
  before do
    url = build_destination_url('denver, co', 'fort collins, co')
    location_response = File.read('spec/fixtures/destinations/good_request_response.json')
    stub_request(:get, url).to_return(status: 200, body: location_response)

    url = build_location_url('Ft Collins, CO')
    location_response = File.read('spec/fixtures/locations/good_request_response.json')
    stub_request(:get, url).to_return(status: 200, body: location_response)

    url = build_forecast_url('41.883229', '-87.632398')
    forecast_response = File.read('spec/fixtures/forecasts/good_request_response.json')
    stub_request(:get, url).to_return(status: 200, body: forecast_response)

    url = build_restaurant_url('Ft Collins, CO', 'burgers')
    forecast_response = File.read('spec/fixtures/restaurants/good_request_response.json')
    stub_request(:get, url).to_return(status: 200, body: forecast_response)
  end

  it 'returns JSON data for location query' do
    output = MunchieFacade.get_munchie('denver, co', 'fort collins, co', 'burgers')

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
