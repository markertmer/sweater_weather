class DestinationService < ApplicationService
  class << self

    def get_destination(start, finish)
      get_response_body(url, destination_params(start, finish))
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
