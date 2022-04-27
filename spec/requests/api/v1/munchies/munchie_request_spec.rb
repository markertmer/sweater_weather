require 'rails_helper'

RSpec.describe 'Munchie Request', type: :request do
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

  it 'returns a successful response' do
    get '/api/v1/munchies?start=denver, co&destination=fort collins, co&food=burgers'

    expect(response).to be_successful
    expect(response.status).to eq 200

    result = JSON.parse(response.body, symbolize_names: true)

    data = result[:data]
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

  it 'sad path: missing query' do
    get '/api/v1/munchies?start=&destination=fort collins, co&food=burgers'

    expect(response.status).to eq 400

    result = JSON.parse(response.body, symbolize_names: true)

    expect(result[:message]).to eq "bad request"
    expect(result[:results]).to eq ([])
  end

  it 'sad path: missing location key' do
    get '/api/v1/munchies?destination=fort collins, co&food=burgers'

    expect(response.status).to eq 400

    result = JSON.parse(response.body, symbolize_names: true)

    expect(result[:message]).to eq "bad request"
    expect(result[:results]).to eq ([])
  end

  it 'sad path: irrelevant key provided' do
    get '/api/v1/forecast?foo=bar'

    expect(response.status).to eq 400

    result = JSON.parse(response.body, symbolize_names: true)

    expect(result[:message]).to eq "bad request"
    expect(result[:results]).to eq ([])
  end

  it 'edge case: irrelevant key provided along with valid location' do
    get '/api/v1/munchies?start=denver, co&destination=fort collins, co&food=burgers&foo=bar'

    expect(response).to be_successful
    expect(response.status).to eq 200

    result = JSON.parse(response.body, symbolize_names: true)

    data = result[:data]
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
