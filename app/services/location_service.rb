class LocationService < ApplicationService
  class << self

    def get_location(query)
      get_response_body(url, location_params(query))
    end

    def url
      'http://www.mapquestapi.com/geocoding/v1/address'
    end

    def location_params(query)
      {
        "location": query,
        "key": ENV['mapquest_key']
      }
    end
  end
end
