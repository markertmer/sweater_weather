require 'rails_helper'

RSpec.describe DayObject, type: :poro do

  before do
    response_body = File.read("spec/fixtures/forecast/good_request_response.json")
    @body = JSON.parse(response_body, symbolize_names: true)
  end

  it 'creates an object with the expected attributes' do
    day = @body[:daily][0]

    object = DayObject.new(day)

    expect(object).to be_instance_of DayObject

    expect(object.description).to eq "light rain"
    expect(object.high_temp).to eq 54
    expect(object.icon_url).to eq "http://openweathermap.org/img/wn/10d@2x.png"
    expect(object.low_temp).to eq 45
    expect(object.name).to eq "Saturday"
    expect(object.precip_amount).to eq 0.14
    expect(object.precip_chance).to eq 39
  end
end
