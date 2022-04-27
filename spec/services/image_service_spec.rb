require 'rails_helper'

RSpec.describe ImageService, type: :service do

  describe 'happy paths' do
    before do
      @url = build_image_url('chicago, il')
      image_response = File.read('spec/fixtures/images/good_request_response.json')
      stub_request(:get, @url).to_return(status: 200, body: image_response)
    end

    it 'gets a response' do
      params = ImageService.image_params('chicago, il')
      url = ImageService.url
      conn = ImageService.faraday_req(url, params)
      response = conn.get
      expect(response.status).to eq 200
    end

    it 'returns data for one image' do
      response = ImageService.get_image('chicago, il')

      expect(response[:total]).to_not eq 0
      expect(response[:results].count).to eq 1

      image_data = response[:results][0]

      expect(image_data[:urls][:full]).to eq "https://images.unsplash.com/photo-1602276506752-cec706667215?crop=entropy&cs=srgb&fm=jpg&ixid=MnwzMjIxNjF8MHwxfHNlYXJjaHwxfHxjaGljYWdvJTJDJTIwaWx8ZW58MHx8fHwxNjUwNzU3Njc2&ixlib=rb-1.2.1&q=85"
      expect(image_data[:alt_description]).to eq "white concrete building during daytime"

      image_credit = image_data[:user]
      expect(image_credit[:name]).to eq "Dylan LaPierre"
      expect(image_credit[:links][:html]).to eq "https://unsplash.com/@drench777"
    end

    describe 'sad paths' do
      it 'bad request: missing query' do
        image_response = File.read('spec/fixtures/images/bad_request_response.json')

        url = build_image_url('')
        stub_request(:get, url).to_return(status: 200, body: image_response)

        response = ImageService.get_image('')

        expect(response[:total]).to eq 0
        expect(response[:results].count).to eq 0
      end
    end
  end
end
