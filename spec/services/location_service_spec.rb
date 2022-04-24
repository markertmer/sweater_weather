require 'rails_helper'

RSpec.describe LocationService, type: :service do

  it 'builds a url' do
    base = 'http://www.mapquestapi.com/geocoding/v1/address?'
    location = "location = chicago, il&"
    key = "appid=#{ENV['mapquest_key']}"

    expected = [base, location, key].join

    expect(LocationService.build_url('chicago, il')).to eq expected
  end

  describe 'http requests' do
    before do
      @url = LocationService.build_url('chicago, il')

      location_response = File.read('spec/fixtures/locations/good_request_response.json')

      stub_request(:get, @url).to_return(status: 200, body: location_response)
    end

    it 'gets a response' do
      response = LocationService.send_request(@url)
      expect(response.status).to eq 200
    end

    it 'returns location data' do
      response = LocationService.get_location('chicago, il')

      status = response[:info][:statuscode]
      expect(status).to eq 0

      results = response[:results][0][:locations][0]
      expect(results[:adminArea5]).to eq "Chicago"
      expect(results[:adminArea3]).to eq "IL"
      expect(results[:adminArea1]).to eq "US"

      coordinates = results[:latLng]

      expect(coordinates[:lat]).to eq 41.883229
      expect(coordinates[:lng]).to eq -87.632398
    end

    it 'sad path: bad request' do
      location_response = File.read('spec/fixtures/locations/bad_request_response.json')

      url = LocationService.build_url('')
      stub_request(:get, url).to_return(status: 200, body: location_response)

      response = LocationService.get_location('')

      status = response[:info][:statuscode]
      expect(status).to eq 400

      results = response[:results][0][:locations][0]

      expect(results).to eq nil
    end
  end
end
