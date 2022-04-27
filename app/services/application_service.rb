class ApplicationService
  class << self

    def get_response_body(url, params, headers = nil)
      conn = faraday_req(url, params, headers)
      response = conn.get
      json_parse(response)
    end

    def faraday_req(url, parameters, headers = nil)
      Faraday.new(url) do |f|
        if headers != nil
          headers.each do |key, value|
            f.headers[key] = value
          end
        end
        parameters.each do |key, value|
          f.params[key] = value
        end
      end
    end

    def json_parse(response)
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
