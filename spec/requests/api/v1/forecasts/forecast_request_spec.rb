require 'rails_helper'

RSpec.describe 'Forecast Request', type: :request do
  before do
    @headers = { 'CONTENT_TYPE' => 'application/json', 'Accept' => 'application/json' }

    url = LocationService.build_url('chicago, il')
    location_response = File.read('spec/fixtures/locations/good_request_response.json')
    stub_request(:get, url).to_return(status: 200, body: location_response)

    url = ForecastService.build_url('41.883229', '-87.632398')
    forecast_response = File.read('spec/fixtures/forecasts/good_request_response.json')
    stub_request(:get, url).to_return(status: 200, body: forecast_response)
  end

  it 'returns a successful response' do
    get '/api/v1/forecast?location=chicago, il', headers: @headers

    expect(response).to be_successful
    expect(response.status).to eq 200

    body = JSON.parse(response.body, symbolize_names: true)

    data = body[:data]
    expect(data[:id]).to eq "null"
    expect(data[:type]).to eq "forecast"

    attributes = data[:attributes]

    location_data = attributes[:location]
    expect(location_data[:city]).to eq "Chicago"
    expect(location_data[:state]).to eq "IL"
    expect(location_data[:country]).to eq "US"

    current_data = attributes[:current]
    expect(current_data[:date]).to eq "April 23"
    expect(current_data[:description]).to eq "overcast clouds"
    expect(current_data[:feels_like_temp]).to eq 44
    expect(current_data[:high_temp]).to eq 55
    expect(current_data[:humidity]).to eq 33
    expect(current_data[:icon_url]).to eq "http://openweathermap.org/img/wn/04d@2x.png"
    expect(current_data[:low_temp]).to eq 45
    expect(current_data[:sunrise]).to eq "6:09 AM"
    expect(current_data[:sunset]).to eq "7:47 PM"
    expect(current_data[:temperature]).to eq 50
    expect(current_data[:time]).to eq "7:38 PM"
    expect(current_data[:uv_index]).to eq 0
    expect(current_data[:uv_description]).to eq "low"
    expect(current_data[:visibility]).to eq 6.2

    hourly_data = attributes[:hourly]
    expect(hourly_data).to be_an Array
    expect(hourly_data.count).to eq 48
    first = hourly_data[0]
    expect(first[:time]).to eq "7:00 PM"
    expect(first[:temperature]).to eq 50
    expect(first[:icon_url]).to eq "http://openweathermap.org/img/wn/04d@2x.png"

    daily_data = attributes[:daily]
    expect(daily_data).to be_an Array
    expect(daily_data.count).to eq 8
    first = daily_data[0]
    expect(first[:name]).to eq "Saturday"
    expect(first[:description]).to eq "light rain"
    expect(first[:high_temp]).to eq 55
    expect(first[:icon_url]).to eq "http://openweathermap.org/img/wn/10d@2x.png"
    expect(first[:low_temp]).to eq 45
    expect(first[:precip_amount]).to eq 0.14
    expect(first[:precip_chance]).to eq 39
  end

  it 'sad path: missing query' do
    get '/api/v1/forecast?location=', headers: @headers

    expect(response.status).to eq 400

    result = JSON.parse(response.body, symbolize_names: true)

    expect(result[:message]).to eq "bad request"
    expect(result[:results]).to eq ([])
  end

  it 'sad path: missing location key' do
    get '/api/v1/forecast', headers: @headers

    expect(response.status).to eq 400

    result = JSON.parse(response.body, symbolize_names: true)

    expect(result[:message]).to eq "bad request"
    expect(result[:results]).to eq ([])
  end

  it 'sad path: irrelevant key provided' do
    get '/api/v1/forecast?foo=bar', headers: @headers

    expect(response.status).to eq 400

    result = JSON.parse(response.body, symbolize_names: true)

    expect(result[:message]).to eq "bad request"
    expect(result[:results]).to eq ([])
  end

  it 'sad path: no results found' do
    url_2 = LocationService.build_url('xxxxxxx')
    location_response_2 = File.read('spec/fixtures/locations/no_results_response.json')
    parsed = JSON.parse(location_response_2)
    stub_request(:get, url_2).to_return(status: 200, body: parsed)

    get '/api/v1/forecast?location=xxxxxxx', headers: @headers

    expect(response.status).to eq 404

    result = JSON.parse(response.body, symbolize_names: true)

    expect(result[:message]).to eq 'no results found'
    expect(result[:results]).to eq ([])
  end

  it 'edge case: irrelevant key provided along with valid location' do
    get '/api/v1/forecast?foo=bar&location=chicago, il', headers: @headers

    expect(response).to be_successful
    expect(response.status).to eq 200

    body = JSON.parse(response.body, symbolize_names: true)

    data = body[:data]
    expect(data[:id]).to eq "null"
    expect(data[:type]).to eq "forecast"

    attributes = data[:attributes]

    location_data = attributes[:location]
    expect(location_data[:city]).to eq "Chicago"
    expect(location_data[:state]).to eq "IL"
    expect(location_data[:country]).to eq "US"

    current_data = attributes[:current]
    expect(current_data[:date]).to eq "April 23"
    expect(current_data[:description]).to eq "overcast clouds"
    expect(current_data[:feels_like_temp]).to eq 44
    expect(current_data[:high_temp]).to eq 55
    expect(current_data[:humidity]).to eq 33
    expect(current_data[:icon_url]).to eq "http://openweathermap.org/img/wn/04d@2x.png"
    expect(current_data[:low_temp]).to eq 45
    expect(current_data[:sunrise]).to eq "6:09 AM"
    expect(current_data[:sunset]).to eq "7:47 PM"
    expect(current_data[:temperature]).to eq 50
    expect(current_data[:time]).to eq "7:38 PM"
    expect(current_data[:uv_index]).to eq 0
    expect(current_data[:uv_description]).to eq "low"
    expect(current_data[:visibility]).to eq 6.2

    hourly_data = attributes[:hourly]
    expect(hourly_data).to be_an Array
    expect(hourly_data.count).to eq 48
    first = hourly_data[0]
    expect(first[:time]).to eq "7:00 PM"
    expect(first[:temperature]).to eq 50
    expect(first[:icon_url]).to eq "http://openweathermap.org/img/wn/04d@2x.png"

    daily_data = attributes[:daily]
    expect(daily_data).to be_an Array
    expect(daily_data.count).to eq 8
    first = daily_data[0]
    expect(first[:name]).to eq "Saturday"
    expect(first[:description]).to eq "light rain"
    expect(first[:high_temp]).to eq 55
    expect(first[:icon_url]).to eq "http://openweathermap.org/img/wn/10d@2x.png"
    expect(first[:low_temp]).to eq 45
    expect(first[:precip_amount]).to eq 0.14
    expect(first[:precip_chance]).to eq 39
  end
end
