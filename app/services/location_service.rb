class LocationService < ApplicationService

  def self.get_location(query)
    url = build_url(query)
    get_data(url)
  end

  def self.build_url(query)
    base = 'http://www.mapquestapi.com/geocoding/v1/address?'
    location = "location=#{query}&"
    key = "key=#{ENV['mapquest_key']}"

    [base, location, key].join
  end
end
