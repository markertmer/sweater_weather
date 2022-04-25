require 'rails_helper'

RSpec.describe BackgroundFacade, type: :facade do
  before do
    @url = ImageService.build_url('chicago, il')
    image_response = File.read('spec/fixtures/images/good_request_response.json')
    stub_request(:get, @url).to_return(status: 200, body: image_response)
  end

  it 'returns JSON data for location query' do
    output = BackgroundFacade.get_background('chicago, il')

    image_data = output[:data][:image]
    expect(image_data[:url]).to eq "https://images.unsplash.com/photo-1602276506752-cec706667215?crop=entropy&cs=srgb&fm=jpg&ixid=MnwzMjIxNjF8MHwxfHNlYXJjaHwxfHxjaGljYWdvJTJDJTIwaWx8ZW58MHx8fHwxNjUwNzU3Njc2&ixlib=rb-1.2.1&q=85"
    expect(image_data[:alt_text]).to eq "white concrete building during daytime"

    credit_data = output[:data][:credits]
    expect(credit_data[:source_name]).to eq "Dylan LaPierre"
    expect(credit_data[:source_url]).to eq "https://unsplash.com/@drench777"
    expect(credit_data[:unsplash_url]).to eq "https://unsplash.com/?utm_source=sweater_weather&utm_medium=referral"
  end
end
