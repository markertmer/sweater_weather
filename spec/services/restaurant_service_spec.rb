require 'rails_helper'

RSpec.describe RestaurantService, type: :service do

  describe 'happy paths' do
    before do
      @url = build_restaurant_url('fort collins, co', 'burgers')
      yelp_response = File.read('spec/fixtures/restaurants/good_request_response.json')

      stub_request(:get, @url).to_return(status: 200, body: yelp_response)
    end

    it 'gets a response' do
      url = RestaurantService.url
      params = RestaurantService.restaurant_params('fort collins, co', 'burgers')
      headers = RestaurantService.headers
      conn = RestaurantService.faraday_req(url, params, headers)
      response = conn.get
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
