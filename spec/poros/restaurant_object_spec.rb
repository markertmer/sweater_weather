require 'rails_helper'

RSpec.describe RestaurantObject, type: :poro do

  before do
    response_body = File.read("spec/fixtures/restaurants/good_request_response.json")
    body = JSON.parse(response_body, symbolize_names: true)

    top_result = body[:businesses][0]

    @restaurant = RestaurantObject.new(top_result)
  end

  it 'has a name and an address' do
    expect(@restaurant.name).to eq "Big AL'S Burgers & Dogs"
    expect(@restaurant.address).to eq "140 W Mountain Ave, Fort Collins, CO 80524"
  end
end
