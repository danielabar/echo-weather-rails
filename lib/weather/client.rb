module Weather
  class Client
    def initialize(conn = nil)
      @conn = conn || Faraday.new(
        url: ENV.fetch("WEATHER_API_URL"),
        params: { key: ENV.fetch("WEATHER_API_KEY", nil) },
        headers: { "Accept" => "application/json" }
      )
    end

    def today(city:)
      endpoint = "current.json"
      params = { q: city, aqi: "yes" }
      response = @conn.get(endpoint, params)
      Rails.logger.debug { "Weather API Response for #{city}: #{response.body}" }

      if response.status.between?(400, 499)
        handle_api_error(response, city)
      elsif response.status >= 500
        handle_server_error(response, city)
      else
        JSON.parse(response.body)
      end
    end

    private

    def handle_api_error(response, city)
      error_data = JSON.parse(response.body)["error"]
      error_code = error_data["code"]
      error_message = error_data["message"]
      log_error(city, response.status, error_code, error_message)

      raise Weather::ApiError.new(error_code, error_message)
    rescue JSON::ParserError
      raise Weather::ApiError.new(response.status, "Unexpected API error format.")
    end

    def handle_server_error(response, city)
      log_error(city, response.status, nil, "Server error occurred.")
      raise Weather::ApiError.new(response.status, "Server error occurred.")
    end

    def log_error(city, status, error_code, error_message)
      Rails.logger.error do
        "Weather API Error for #{city}: " \
          "Status: #{status}, Code: #{error_code || 'N/A'}, Message: #{error_message || 'N/A'}"
      end
    end
  end
end
