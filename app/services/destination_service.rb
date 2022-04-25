class DestinationService < ApplicationService

  def self.get_destination(start, finish)
    url = build_url(start, finish)
    response = get_data(url)
  end

  def self.build_url(start, finish)
    base = 'http://www.mapquestapi.com/directions/v2/route?'
    key = "key=#{ENV['mapquest_key']}&"
    from = "from=#{start}&"
    to = "to=#{finish}"

    [base, key, from, to].join
  end
end
