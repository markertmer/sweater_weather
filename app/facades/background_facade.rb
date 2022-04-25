class BackgroundFacade

  def self.get_background(query)
    response = ImageService.get_image(query)

    if response[:results] == []
      NoResultsSerializer.response
    else
      object = ImageObject.new(response)
      BackgroundSerializer.format_data(object)
    end
  end
end
