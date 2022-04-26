class DestinationObject

  attr_reader :city, :start_city, :travel_minutes, :travel_time

  def initialize(data)
    @city = get_city(data[:locations][1])
    @start_city = get_city(data[:locations][0])
    @travel_time = get_travel_time(data[:legs])
  end

  def get_city(location)
    city = location[:adminArea5]
    state = location[:adminArea3]
    [city, state].join(", ")
  end

  def get_travel_time(legs)
    @travel_minutes = (legs.sum do |leg|
      leg[:maneuvers].sum do |maneuver|
        maneuver[:time]
      end
    end.to_f / 60).ceil

    hours = "#{@travel_minutes / 60} hours" unless @travel_minutes < 60
    minutes = "#{@travel_minutes % 60} minutes" unless @travel_minutes % 60 == 0

    [hours, minutes].join(" ").strip
  end
end
