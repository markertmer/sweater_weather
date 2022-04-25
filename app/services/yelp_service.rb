class YelpService < ApplicationService

  def self.get_data(location, query)
    url = build_url(location, query)
    get_yelp_data(url)
  end

  def self.build_url(location, query)
    base = 'https://api.yelp.com/v3/businesses/search?'
    location = "location=#{location}&"
    search = "term=#{query}"

    [base, location, search].join
  end

  def self.get_yelp_data(url)
    response = Faraday.new(url) do |faraday|
      faraday.headers["Authorization"] = ["Bearer #{ENV['yelp_key']}"]
    end.get
    json_parse(response)
  end
end
