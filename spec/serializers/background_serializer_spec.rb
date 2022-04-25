require 'rails_helper'

RSpec.describe BackgroundSerializer, type: :serializer do
  before do
    response_body = File.read("spec/fixtures/images/good_request_response.json")
    body = JSON.parse(response_body, symbolize_names: true)
    @image_poro = ImageObject.new(body)
  end

  it 'converts PORO to JSON' do
    output = BackgroundSerializer.format_data(@image_poro)

    image_data = output[:data][:image]
    expect(image_data[:url]).to eq "https://images.unsplash.com/photo-1602276506752-cec706667215?crop=entropy&cs=srgb&fm=jpg&ixid=MnwzMjIxNjF8MHwxfHNlYXJjaHwxfHxjaGljYWdvJTJDJTIwaWx8ZW58MHx8fHwxNjUwNzU3Njc2&ixlib=rb-1.2.1&q=85"
    expect(image_data[:alt_text]).to eq "white concrete building during daytime"

    credit_data = output[:data][:credits]
    expect(credit_data[:source_name]).to eq "Dylan LaPierre"
    expect(credit_data[:source_url]).to eq "https://unsplash.com/@drench777"
    expect(credit_data[:unsplash_url]).to eq "https://unsplash.com/?utm_source=sweater_weather&utm_medium=referral"
  end
end
