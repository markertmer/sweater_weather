class DestinationObject

  attr_reader :city, :travel_time

  def initialize(data)
    @city = get_city(data[:locations][1])
    @travel_time = get_travel_time(data[:legs])
  end

  def get_city(location)
    city = location[:adminArea5]
    state = location[:adminArea3]
    [city, state].join(", ")
  end

  def get_travel_time(legs)
    total_minutes = (legs.sum do |leg|
      leg[:maneuvers].sum do |maneuver|
        maneuver[:time]
      end
    end.to_f / 60).ceil

    hours = "#{total_minutes / 60} hours" unless total_minutes < 60
    minutes = "#{total_minutes % 60} minutes" unless total_minutes % 60 == 0

    [hours, minutes].join(" ").strip
  end
end
