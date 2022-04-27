require 'rails_helper'

RSpec.describe 'Road Trip Request', type: :request do
  before do
    User.create(email: "a@b.c", password: "cliff666", api_key: "945V86HV2349586VY243982V56987V5698VB2695087B62N08")

    @headers = { 'CONTENT_TYPE' => 'application/json', 'Accept' => 'application/json' }

    @request_body = {
      "origin": "denver, co",
      "destination": "fort collins, co",
      "api_key": "945V86HV2349586VY243982V56987V5698VB2695087B62N08"
    }.to_json

    url = build_destination_url('denver, co', 'fort collins, co')
    location_response = File.read('spec/fixtures/destinations/good_request_response.json')
    stub_request(:get, url).to_return(status: 200, body: location_response)

    url = build_location_url('Ft Collins, CO')
    location_response = File.read('spec/fixtures/locations/good_request_response.json')
    stub_request(:get, url).to_return(status: 200, body: location_response)

    url = build_forecast_url('41.883229', '-87.632398')
    forecast_response = File.read('spec/fixtures/forecasts/good_request_response.json')
    stub_request(:get, url).to_return(status: 200, body: forecast_response)
  end

  it 'returns a successful response' do
    post '/api/v1/road_trip',
        headers: @headers,
        params: @request_body

    expect(response).to be_successful
    expect(response.status).to eq 200

    body = JSON.parse(response.body, symbolize_names: true)

    data = body[:data]
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

  it 'sad path: missing query' do
    request_body = {
      "origin": "",
      "destination": "fort collins, co",
      "api_key": "945V86HV2349586VY243982V56987V5698VB2695087B62N08"
    }.to_json

    post '/api/v1/road_trip',
        headers: @headers,
        params: request_body

    expect(response.status).to eq 400

    result = JSON.parse(response.body, symbolize_names: true)

    expect(result[:message]).to eq "bad request"
    expect(result[:results]).to eq ([])
  end

  it 'sad path: missing key/value' do
    request_body = {
      "origin": "denver, co",
      "api_key": "945V86HV2349586VY243982V56987V5698VB2695087B62N08"
    }.to_json

    post '/api/v1/road_trip',
        headers: @headers,
        params: request_body

    expect(response.status).to eq 400

    result = JSON.parse(response.body, symbolize_names: true)

    expect(result[:message]).to eq "bad request"
    expect(result[:results]).to eq ([])
  end

  it 'sad path: incorrect api key provided' do
    request_body = {
      "origin": "denver, co",
      "destination": "fort collins, co",
      "api_key": "notthekey"
    }.to_json

    post '/api/v1/road_trip',
        headers: @headers,
        params: request_body

    expect(response.status).to eq 401

    result = JSON.parse(response.body, symbolize_names: true)

    expect(result[:message]).to eq "Invalid credentials"
  end

  it 'sad path: impossible route provided' do
    request_body = {
      "origin": "new york, ny",
      "destination": "london, england",
      "api_key": "945V86HV2349586VY243982V56987V5698VB2695087B62N08"
    }.to_json

    post '/api/v1/road_trip',
        headers: @headers,
        params: request_body

    expect(response.status).to eq 200

    body = JSON.parse(response.body, symbolize_names: true)

    data = body[:data]
    expect(data[:id]).to eq "null"
    expect(data[:type]).to eq "roadtrip"

    attributes = data[:attributes]
    expect(attributes[:start_city]).to eq "new york, ny"
    expect(attributes[:end_city]).to eq "london, england"
    expect(attributes[:travel_time]).to eq "impossible"

    weather = attributes[:weather_at_eta]
    expect(weather).to eq ({})
  end

  it 'edge case: irrelevant key provided along with valid location' do
    request_body = {
      "origin": "Denver, CO",
      "destination": "Ft Collins, CO",
      "foo": "bar",
      "api_key": "945V86HV2349586VY243982V56987V5698VB2695087B62N08"
    }.to_json

    post '/api/v1/road_trip',
        headers: @headers,
        params: request_body

    expect(response).to be_successful
    expect(response.status).to eq 200

    body = JSON.parse(response.body, symbolize_names: true)

    data = body[:data]
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
