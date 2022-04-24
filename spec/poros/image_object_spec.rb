require 'rails_helper'

RSpec.describe ImageObject, type: :poro do

  before do
    response_body = File.read("spec/fixtures/images/good_request_response.json")
    body = JSON.parse(response_body, symbolize_names: true)

    @image = ImageObject.new(body)
  end

  it 'has functional attributes' do
    expect(@image.url).to eq "https://images.unsplash.com/photo-1602276506752-cec706667215?crop=entropy&cs=srgb&fm=jpg&ixid=MnwzMjIxNjF8MHwxfHNlYXJjaHwxfHxjaGljYWdvJTJDJTIwaWx8ZW58MHx8fHwxNjUwNzU3Njc2&ixlib=rb-1.2.1&q=85"
    expect(@image.alt_text).to eq "white concrete building during daytime"
  end

  it 'has source data' do
    expect(@image.source_name).to eq "Dylan LaPierre"
    expect(@image.source_url).to eq "https://unsplash.com/@drench777"
    expect(@image.unsplash_url).to eq "https://unsplash.com/?utm_source=sweater_weather&utm_medium=referral"
  end
end
