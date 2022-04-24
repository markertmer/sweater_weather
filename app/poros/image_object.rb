class ImageObject

  attr_reader :url, :alt_text, :source_name, :source_url, :unsplash_url

  def initialize(body)
    image_data = body[:results][0]
    @url = image_data[:urls][:full]
    @alt_text = image_data[:alt_description]

    credit_data = image_data[:user]
    @source_name = credit_data[:name]
    @source_url = credit_data[:links][:html]

    @unsplash_url = "https://unsplash.com/?utm_source=sweater_weather&utm_medium=referral"
  end
end
