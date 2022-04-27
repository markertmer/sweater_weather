class RestaurantService < ApplicationService
  class << self
    def get_restaurant(location, query)
      get_response_body(url, restaurant_params(location, query), headers)
    end

    def url
      'https://api.yelp.com/v3/businesses/search'
    end

    def restaurant_params(location, query)
      {
        "location": location,
        "category": "restaurants",
        "term": query
      }
    end

    def headers
      {
        "Authorization": "Bearer #{ENV['yelp_key']}"
      }
    end
  end
end
