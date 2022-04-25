require 'rails_helper'

RSpec.describe DestinationService, type: :service do

  it 'builds a url' do
    base = 'http://www.mapquestapi.com/directions/v2/route?'
    key = "key=#{ENV['mapquest_key']}&"
    from = "from=denver, co&"
    to = "to=fort collins, co"

    expected = [base, key, from, to].join

    expect(DestinationService.build_url('denver, co', 'fort collins, co')).to eq expected
  end

  describe 'http requests' do
    before do
      @url = DestinationService.build_url('denver, co', 'fort collins, co')
      response_body = File.read('spec/fixtures/destinations/good_request_response.json')

      stub_request(:get, @url).to_return(status: 200, body: response_body)
    end

    it 'gets a response' do
      response = DestinationService.send_request(@url)
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
end
