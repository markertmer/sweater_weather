class ImageService < ApplicationService
  class << self

    def get_image(location)
      Rails.cache.fetch("get_location_#{location}", expires_in: 7.days) do
        get_response_body(url, image_params(location))
      end
    end

    def url
      'https://api.unsplash.com/search/photos'
    end

    def image_params(location)
      {
        "query": location,
        "order_by": "relevant",
        "page": "1",
        "per_page": "1",
        "client_id": ENV['unsplash_key']
      }
    end
  end
end
