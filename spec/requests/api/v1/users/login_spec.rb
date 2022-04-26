require 'rails_helper'

RSpec.describe 'Login User', type: :request do
  before do
    @user = User.create(email: 'jane@zone.biz', password: 'zone-pwd', api_key: '23498VN7245968N72354629345867N23P409N52')

    @request_body = {
      "email": "jane@zone.biz",
      "password": "zone-pwd",
    }.to_json

    @headers = { 'CONTENT_TYPE' => 'application/json', 'Accept' => 'application/json' }

  end

  it 'authenticates existing user & responds' do
    post '/api/v1/sessions', headers: @headers, params: @request_body

    expect(response.status).to eq 200
    body = JSON.parse(response.body, symbolize_names: true)

    data = body[:data]
    expect(data[:type]).to eq "users"
    expect(data[:id]).to_not be nil

    attributes = data[:attributes]
    expect(attributes[:email]).to eq "jane@zone.biz"
    expect(attributes[:api_key]).to eq "23498VN7245968N72354629345867N23P409N52"
  end

  describe 'sad paths' do
    it 'user does not exist' do
      post '/api/v1/sessions', headers: @headers, params: @request_body

      request_body = {
        "email": "zzzzzzz@yyyyy.com",
        "password": "abcd1234",
      }.to_json

      post '/api/v1/sessions', headers: @headers, params: request_body

      expect(response.status).to eq 401

      response_body = JSON.parse(response.body, symbolize_names: true)
      expect(response_body[:message]).to eq "Invalid credentials"
    end

    it 'incorrect password' do
      request_body = {
        "email": "jane@zone.biz",
        "password": "-------",
      }.to_json

      post '/api/v1/sessions', headers: @headers, params: request_body

      expect(response.status).to eq 401

      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body[:message]).to eq "Invalid credentials"
    end

    it 'missing attributes' do
      request_body = {
        "email": "",
        "password": "",
      }.to_json

      post '/api/v1/sessions', headers: @headers, params: request_body

      expect(response.status).to eq 401

      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body[:message]).to eq "Invalid credentials"
    end

    it 'no body sent' do
      post '/api/v1/sessions', headers: @headers

      expect(response.status).to eq 401

      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body[:message]).to eq "Invalid credentials"
    end
  end

  describe 'edge cases' do
    it 'doesnt break when extra params are sent' do
      request_body = {
        "email": "jane@zone.biz",
        "password": "zone-pwd",
        "foo": "bar"
      }.to_json

      post '/api/v1/sessions', headers: @headers, params: request_body

      expect(response.status).to eq 200
      body = JSON.parse(response.body, symbolize_names: true)

      data = body[:data]
      expect(data[:type]).to eq "users"
      expect(data[:id]).to_not be nil

      attributes = data[:attributes]
      expect(attributes[:email]).to eq "jane@zone.biz"
      expect(attributes[:api_key]).to eq "23498VN7245968N72354629345867N23P409N52"
    end
  end
end
