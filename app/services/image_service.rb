class ImageService < ApplicationService

  def self.get_image(location)
    url = build_url(location)
    get_data(url)
  end

  def self.build_url(location)
    base = 'https://api.unsplash.com/search/photos?'
    key = "client_id=#{ENV['unsplash_key']}&"
    options = 'order_by=relevant&page=1&per_page=1&'
    query = "query=#{location}"

    [base, key, options, query].join
  end
end
