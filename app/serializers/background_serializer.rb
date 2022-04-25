class BackgroundSerializer

  def self.format_data(object)
    {
      "data": {
        "image": {
          "url": object.url,
          "alt_text": object.alt_text
        },
        "credits": {
          "source_name": object.source_name,
          "source_url": object.source_url,
          "unsplash_url": object.unsplash_url
        }
      }
    }
  end
end
