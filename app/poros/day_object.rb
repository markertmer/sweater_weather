class DayObject < ForecastObject

  attr_reader :description,
              :high_temp,
              :icon_url,
              :low_temp,
              :name,
              :precip_amount,
              :precip_chance

  def initialize(day)
    @description = day[:weather][0][:description]
    @high_temp = day[:temp][:max].round
    @icon_url = get_icon_url(day[:weather][0][:icon])
    @low_temp = day[:temp][:min].round
    @name = get_day_name(day[:dt])
    @precip_amount = get_precip_amount(day[:rain], day[:snow])
    @precip_chance = (day[:pop] * 100).to_i # to convert from decimal to percent
  end

  def get_precip_amount(rain, snow)
    rain = 0 if rain == nil
    snow = 0 if snow == nil

    rain.to_f + snow
  end

  def get_day_name(timestamp)
    Time.at(timestamp).to_datetime.strftime("%A")
  end
end
