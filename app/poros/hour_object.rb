class HourObject < ForecastObject

  attr_reader :description, :icon_url, :temperature, :time

  def initialize(hour)
    @description = hour[:weather][0][:description]
    @icon_url = get_icon_url(hour[:weather][0][:icon])
    @temperature = hour[:temp].round
    @time = get_time(hour[:dt])
  end
end
