require 'rails_helper'

RSpec.describe 'Background Request', type: :request do
  before do
    @headers = { 'CONTENT_TYPE' => 'application/json', 'Accept' => 'application/json' }

    url_1 = ImageService.build_url('chicago, il')
    image_response_1 = File.read('spec/fixtures/images/good_request_response.json')
    stub_request(:get, url_1).to_return(status: 200, body: image_response_1)
  end

  it 'returns a successful response' do
    get '/api/v1/backgrounds?location=chicago, il', headers: @headers

    expect(response).to be_successful
    expect(response.status).to eq 200

    body = JSON.parse(response.body, symbolize_names: true)

    data = body[:data]
    expect(data[:id]).to eq "null"
    expect(data[:type]).to eq "image"

    image_data = data[:attributes][:image]
    expect(image_data[:url]).to eq "https://images.unsplash.com/photo-1602276506752-cec706667215?crop=entropy&cs=srgb&fm=jpg&ixid=MnwzMjIxNjF8MHwxfHNlYXJjaHwxfHxjaGljYWdvJTJDJTIwaWx8ZW58MHx8fHwxNjUwNzU3Njc2&ixlib=rb-1.2.1&q=85"
    expect(image_data[:alt_text]).to eq "white concrete building during daytime"

    credit_data = data[:attributes][:credits]
    expect(credit_data[:source_name]).to eq "Dylan LaPierre"
    expect(credit_data[:source_url]).to eq "https://unsplash.com/@drench777"
    expect(credit_data[:unsplash_url]).to eq "https://unsplash.com/?utm_source=sweater_weather&utm_medium=referral"
  end

  it 'sad path: missing query' do
    get '/api/v1/backgrounds?location=', headers: @headers

    expect(response.status).to eq 400

    result = JSON.parse(response.body, symbolize_names: true)

    expect(result[:message]).to eq "bad request"
    expect(result[:results]).to eq ([])
  end

  it 'sad path: missing location key' do
    get '/api/v1/backgrounds', headers: @headers

    expect(response.status).to eq 400

    result = JSON.parse(response.body, symbolize_names: true)

    expect(result[:message]).to eq "bad request"
    expect(result[:results]).to eq ([])
  end

  it 'sad path: irrelevant key provided' do
    get '/api/v1/backgrounds?foo=bar', headers: @headers

    expect(response.status).to eq 400

    result = JSON.parse(response.body, symbolize_names: true)

    expect(result[:message]).to eq "bad request"
    expect(result[:results]).to eq ([])
  end

  it 'sad path: no results found' do
    url_2 = ImageService.build_url('9987ITYNxx')
    image_response_2 = File.read('spec/fixtures/images/bad_request_response.json')
    stub_request(:get, url_2).to_return(status: 200, body: image_response_2)

    get '/api/v1/backgrounds?location=9987ITYNxx', headers: @headers

    expect(response.status).to eq 404

    result = JSON.parse(response.body, symbolize_names: true)

    expect(result[:message]).to eq 'no results found'
    expect(result[:results]).to eq ([])
  end

  it 'edge case: irrelevant key provided along with valid location' do
    get '/api/v1/backgrounds?foo=bar&location=chicago, il', headers: @headers

    expect(response).to be_successful
    expect(response.status).to eq 200

    body = JSON.parse(response.body, symbolize_names: true)

    data = body[:data]
    expect(data[:id]).to eq "null"
    expect(data[:type]).to eq "image"

    image_data = data[:attributes][:image]
    expect(image_data[:url]).to eq "https://images.unsplash.com/photo-1602276506752-cec706667215?crop=entropy&cs=srgb&fm=jpg&ixid=MnwzMjIxNjF8MHwxfHNlYXJjaHwxfHxjaGljYWdvJTJDJTIwaWx8ZW58MHx8fHwxNjUwNzU3Njc2&ixlib=rb-1.2.1&q=85"
    expect(image_data[:alt_text]).to eq "white concrete building during daytime"

    credit_data = data[:attributes][:credits]
    expect(credit_data[:source_name]).to eq "Dylan LaPierre"
    expect(credit_data[:source_url]).to eq "https://unsplash.com/@drench777"
    expect(credit_data[:unsplash_url]).to eq "https://unsplash.com/?utm_source=sweater_weather&utm_medium=referral"
  end
end
