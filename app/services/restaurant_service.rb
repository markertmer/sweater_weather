class RestaurantService < ApplicationService

  def self.get_restaurant(location, query)
    url = build_url(location, query)
    response = get_yelp_data(url)
    json_parse(response)
  end

  def self.build_url(location, query)
    base = 'https://api.yelp.com/v3/businesses/search?'
    location = "location=#{location}&"
    category = "category=restaurants"
    search = "term=#{query}"

    [base, location, search].join
  end

  def self.get_yelp_data(url)
    Faraday.new(url) do |faraday|
      faraday.headers["Authorization"] = ["Bearer #{ENV['yelp_key']}"]
    end.get
  end
end
