class LocationObject

  attr_reader :city, :state, :country, :latitude, :longitude

  def initialize(data)
    @city = data[:adminArea5]
    @state = data[:adminArea3]
    @country = data[:adminArea1]
    @latitude = data[:latLng][:lat]
    @longitude = data[:latLng][:lng]
  end
end
