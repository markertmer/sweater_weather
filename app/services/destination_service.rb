class DestinationService < ApplicationService
  class << self

    def get_destination(start, finish)
      Rails.cache.fetch("get_destination_#{start}_#{finish}", expires_in: 7.days) do
        get_response_body(url, destination_params(start, finish))
      end
    end

    def url
      'http://www.mapquestapi.com/directions/v2/route'
    end

    def destination_params(start, finish)
      {
        "from": start,
        "to": finish,
        "key": ENV['mapquest_key']
      }
    end
  end
end
