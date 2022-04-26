require 'rails_helper'

RSpec.describe 'New User', type: :request do
  before do
    @request_body = {
      "email": "whatever@example.com",
      "password": "password",
      "password_confirmation": "password"
    }.to_json

    @headers = { 'CONTENT_TYPE' => 'application/json', 'Accept' => 'application/json' }

  end

  it 'creates a new user' do
    post '/api/v1/users', headers: @headers, params: @request_body

    user = User.last
    expect(user.email).to eq "whatever@example.com"
    expect(user.password_digest).to_not be nil
    expect(user.api_key).to_not be nil
    expect(user.api_key.length).to be 69
  end

  it 'sends a response' do
    post '/api/v1/users', headers: @headers, params: @request_body
    
    expect(response.status).to eq 201
    body = JSON.parse(response.body, symbolize_names: true)

    data = body[:data]
    expect(data[:type]).to eq "users"
    expect(data[:id]).to_not be nil

    attributes = data[:attributes]
    expect(attributes[:email]).to eq "whatever@example.com"
    expect(attributes[:api_key]).to_not be nil
    expect(attributes[:api_key].length).to be 69
  end

  describe 'sad paths' do
    it 'email address is not unique' do
      post '/api/v1/users', headers: @headers, params: @request_body

      request_body = {
        "email": "whatever@example.com",
        "password": "abcd1234",
        "password_confirmation": "abcd1234"
      }.to_json

      post '/api/v1/users', headers: @headers, params: request_body

      expect(response.status).to eq 400

      response_body = JSON.parse(response.body, symbolize_names: true)
      expect(response_body[:message]).to eq "Email has already been taken"
    end

    it 'password does not match confirmation' do
      request_body = {
        "email": "bliff@pip.com",
        "password": "abcd1234",
        "password_confirmation": "xyz666"
      }.to_json

      post '/api/v1/users', headers: @headers, params: request_body

      expect(response.status).to eq 400

      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body[:message]).to eq "Password confirmation doesn't match Password"
    end

    it 'missing attributes' do
      request_body = {
        "email": "",
        "password": "",
        "password_confirmation": ""
      }.to_json

      post '/api/v1/users', headers: @headers, params: request_body

      expect(response.status).to eq 400

      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body[:message]).to eq "Email can't be blank, Password digest can't be blank, Password can't be blank"
    end

    it 'no body sent' do
      post '/api/v1/users', headers: @headers

      expect(response.status).to eq 400

      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body[:message]).to eq "Email can't be blank, Password digest can't be blank, Password can't be blank"
    end
  end

  describe 'edge cases' do
    it 'doesnt break when extra params are sent' do
      request_body = {
        "email": "bliff@pip.com",
        "password": "abcd1234",
        "password_confirmation": "abcd1234",
        "foo": "bar"
      }.to_json

      post '/api/v1/users', headers: @headers, params: request_body

      expect(response.status).to eq 201
      body = JSON.parse(response.body, symbolize_names: true)

      data = body[:data]
      expect(data[:type]).to eq "users"
      expect(data[:id]).to_not be nil

      attributes = data[:attributes]
      expect(attributes[:email]).to eq "bliff@pip.com"
      expect(attributes[:api_key]).to_not be nil
      expect(attributes[:api_key].length).to be 69
    end
  end
end
