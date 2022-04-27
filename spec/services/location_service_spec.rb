require 'rails_helper'

RSpec.describe LocationService, type: :service do

  describe 'happy paths' do
    before do
      @url = build_location_url('chicago, il')

      location_response = File.read('spec/fixtures/locations/good_request_response.json')
      stub_request(:get, @url).to_return(status: 200, body: location_response)
    end

    it 'gets a response' do
      params = LocationService.location_params('chicago, il')
      url = LocationService.url
      conn = LocationService.faraday_req(url, params)
      response = conn.get
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

    describe 'sad paths' do
      it 'bad request: location missing' do

        url = build_location_url('')

        location_response = File.read('spec/fixtures/locations/bad_request_response.json')
        stub_request(:get, url).to_return(status: 200, body: location_response)

        response = LocationService.get_location('')

        status = response[:info][:statuscode]
        expect(status).to eq 400

        results = response[:results][0][:locations][0]
        expect(results).to eq nil
      end
    end
  end
end
