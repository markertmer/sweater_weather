require 'rails_helper'

RSpec.describe DestinationService, type: :service do
  describe 'happy paths' do
    before do
      @url = build_destination_url('denver, co', 'fort collins, co')
      response_body = File.read('spec/fixtures/destinations/good_request_response.json')

      stub_request(:get, @url).to_return(status: 200, body: response_body)
    end

    it 'gets a response' do
      params = DestinationService.destination_params('denver, co', 'fort collins, co')
      url = DestinationService.url
      conn = DestinationService.faraday_req(url, params)
      response = conn.get
      expect(response.status).to eq 200
    end

    it 'returns destination data' do
      response = DestinationService.get_destination('denver, co', 'fort collins, co')

      travel_time = (response[:route][:legs].sum do |leg|
        leg[:maneuvers].sum do |maneuver|
          maneuver[:time]
        end
      end.to_f / 60).ceil

      expect(travel_time).to eq 64

      city = response[:route][:locations][1][:adminArea5]
      state = response[:route][:locations][1][:adminArea3]
      destination = [city, state].join(", ")

      expect(destination).to eq "Ft Collins, CO"
    end

  end

  describe 'sad paths' do
    it 'impossible driving route' do
      url = build_destination_url('new york, ny', 'london, england')
      response_body = File.read('spec/fixtures/destinations/no_route_response.json')

      stub_request(:get, url).to_return(status: 200, body: response_body)

      response = DestinationService.get_destination('new york, ny', 'london, england')

      route = response[:route]
      expect(route.keys).to include :routeError

      status = response[:info][:statuscode]
      expect(status).to eq 402

      message = response[:info][:messages][0]
      expect(message).to eq "We are unable to route with the given locations."
    end
  end
end
