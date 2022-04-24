class ApplicationService

  def self.get_data(url)
    response = send_request(url)
    json_parse(response)
  end

  def self.send_request(url)
    Faraday.get(url)
  end

  def self.json_parse(response)
    JSON.parse(response.body, symbolize_names: true)
  end
end
