class ForecastObject

  attr_reader :date,
              :days,
              :description,
              :feels_like_temp,
              :high_temp,
              :hours,
              :humidity,
              :icon_url,
              :low_temp,
              :sunrise,
              :sunset,
              :temperature,
              :time,
              :uv_index,
              :uv_description,
              :visibility

  def initialize(data)
    build_current(data[:current], data[:daily][0][:temp])
    build_hours(data[:hourly])
    build_days(data[:daily])
  end

  def build_current(current_data, current_day_temps)
    @date = get_date(current_data[:dt])
    @description = current_data[:weather][0][:description]
    @feels_like_temp = current_data[:feels_like].round
    @high_temp = current_day_temps[:max].round
    @humidity = current_data[:humidity]
    @icon_url = get_icon_url(current_data[:weather][0][:icon])
    @low_temp = current_day_temps[:min].round
    @sunrise = get_time(current_data[:sunrise])
    @sunset = get_time(current_data[:sunset])
    @temperature = current_data[:temp].round
    @time = get_time(current_data[:dt])
    @uv_index = current_data[:uvi]
    @uv_description = get_uv_description(current_data[:uvi])
    @visibility = convert_visibility(current_data[:visibility])
  end

  def build_hours(hourly_data)
    @hours = hourly_data.map do |hour|
      HourObject.new(hour)
    end
  end

  def build_days(daily_data)
    @days = daily_data.map do |day|
      DayObject.new(day)
    end
  end

  def get_date(timestamp)
    Time.at(timestamp).to_datetime.strftime("%B %-d")
  end

  def get_time(timestamp)
    Time.at(timestamp).to_datetime.strftime("%l:%M %p").strip
  end

  def get_icon_url(icon_code)
    "http://openweathermap.org/img/wn/#{icon_code}@2x.png"
  end

  def convert_visibility(meters)
    miles = (meters.to_f / 1609).round(1)
  end

  def get_uv_description(uvi)
    if uvi >= 8
      "very high"
    elsif uvi >= 6
      "high"
    elsif uvi >= 3
      "moderate"
    else
      "low"
    end
  end
end
