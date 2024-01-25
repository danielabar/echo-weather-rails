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
      JSON.parse(response.body)
    end
  end
end
