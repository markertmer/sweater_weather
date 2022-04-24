class HourObject < ForecastObject

  attr_reader :icon_url, :temperature, :time

  def initialize(hour)
    @icon_url = get_icon_url(hour[:weather][0][:icon])
    @temperature = hour[:temp].round
    @time = get_time(hour[:dt])
  end

  # def get_icon_url(icon_code)
  #   "http://openweathermap.org/img/wn/#{icon_code}@2x.png"
  # end
  #
  # def get_time(timestamp)
  #   Time.at(timestamp).to_datetime.strftime("%l:%M %p").strip
  # end

end
