require 'rails_helper'

RSpec.describe RestaurantService, type: :service do

  it 'builds a url' do
    base = 'https://api.yelp.com/v3/businesses/search?'
    location = "location=fort collins, co&"
    category = "category=restaurants"
    search = "term=burgers"

    expected = [base, location, search].join

    expect(RestaurantService.build_url('fort collins, co', 'burgers')).to eq expected
  end

  describe 'http requests' do
    before do
      @url = RestaurantService.build_url('fort collins, co', 'burgers')
      yelp_response = File.read('spec/fixtures/restaurants/good_request_response.json')

      stub_request(:get, @url).to_return(status: 200, body: yelp_response)
    end

    it 'gets a response' do
      response = RestaurantService.get_yelp_data(@url)
      expect(response.status).to eq 200
    end

    it 'returns restaurant data' do
      response = RestaurantService.get_restaurant('fort collins, co', 'burgers')

      restaurant = response[:businesses][0]
      name = restaurant[:name]
      address = restaurant[:location][:display_address].join(", ")

      expect(name).to eq "Big AL'S Burgers & Dogs"
      expect(address).to eq "140 W Mountain Ave, Fort Collins, CO 80524"
    end
  end
end
