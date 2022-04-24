require 'rails_helper'

RSpec.describe HourObject, type: :poro do

  before do
    response_body = File.read("spec/fixtures/forecasts/good_request_response.json")
    @body = JSON.parse(response_body, symbolize_names: true)
  end

  it 'creates an object with the expected attributes' do
    hour = @body[:hourly][0]

    object = HourObject.new(hour)

    expect(object).to be_instance_of HourObject

    expect(object.icon_url).to eq "http://openweathermap.org/img/wn/04d@2x.png"
    expect(object.temperature).to eq 50
    expect(object.time).to eq "7:00 PM"
  end
end
