require 'rails_helper'

RSpec.describe ForecastObject, type: :poro do

  before do
    response_body = File.read("spec/fixtures/forecast/good_request_response.json")
    body = JSON.parse(response_body, symbolize_names: true)

    @forecast = ForecastObject.new(body)
  end

  it 'has current weather data' do
    current = @forecast.current_data
    expect(current).to be_a Hash

    expect(current[:date]).to eq
    expect(current[:description]).to eq
    expect(current[:feels_like_temp]).to eq
    expect(current[:high_temp]).to eq
    expect(current[:humidity]).to eq
    expect(current[:icon_link]).to eq
    expect(current[:low_temp]).to eq
    expect(current[:sunrise]).to eq
    expect(current[:sunset]).to eq
    expect(current[:temperature]).to eq
    expect(current[:time]).to eq
    expect(current[:uv_index]).to eq
    expect(current[:visibility]).to eq
  end

  it 'has hourly weather data' do

  end

  it 'has daily weather data' do

  end
end
