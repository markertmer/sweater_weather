require 'rails_helper'

RSpec.describe DestinationObject, type: :poro do

  before do
    response_body = File.read("spec/fixtures/destinations/good_request_response.json")
    body = JSON.parse(response_body, symbolize_names: true)

    data = body[:route]

    @destination = DestinationObject.new(data)
  end

  it 'has a name and an address' do
    expect(@destination.city).to eq "Ft Collins, CO"
    expect(@destination.travel_time).to eq "1 hours 4 minutes"
  end
end
