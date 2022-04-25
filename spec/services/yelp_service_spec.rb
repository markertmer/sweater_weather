require 'rails_helper'

RSpec.describe YelpService, type: :service do

  it 'builds a url' do
    base = 'https://api.yelp.com/v3/businesses/search?'
    location = "location=80521&"
    search = "term=coffee"

    expected = [base, location, search].join

    expect(YelpService.build_url('80521', 'coffee')).to eq expected
  end

  describe 'http requests' do
    # before do
      # @url = YelpService.build_url('80521', 'coffee')
    #
    #   location_response = File.read('spec/fixtures/locations/good_request_response.json')
    #
    #   stub_request(:get, @url).to_return(status: 200, body: location_response)
    # end

    it 'gets a response' do
      response = YelpService.get_data('80521', 'coffee')
      expect(response.status).to eq 200
    end
  end
end
