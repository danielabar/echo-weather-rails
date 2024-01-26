class SearchWeather
  include Interactor

  def call
    address = context.address
    if address.blank?
      context.fail!(error: "Address must be provided")
      return
    end

    forecast = fetch_forecast(address)
    context.weather_current = build_weather_current(forecast)
  rescue Weather::ApiError => e
    context.fail!(error: "Weather API Error: #{e.message}")
  end

  private

  def build_weather_current(forecast)
    current_data = forecast["current"]
    location_data = forecast["location"]
    Weather::Current.new(
      temperature_c: extract_temperature_c(current_data),
      temperature_f: extract_temperature_f(current_data),
      condition: extract_condition(current_data),
      air_quality: air_quality(current_data["air_quality"]["us-epa-index"]),
      icon: current_data["condition"]["icon"],
      location_name: location_data["name"],
      region: location_data["region"],
      country: location_data["country"]
    )
  end

  def extract_temperature_c(data)
    data["temp_c"].to_f
  end

  def extract_temperature_f(data)
    data["temp_f"].to_f
  end

  def extract_condition(data)
    data["condition"]["text"]
  end

  def fetch_forecast(address)
    context.from_cache = true
    Rails.cache.fetch(address, expires_in: 30.minutes) do
      context.from_cache = false
      Weather::Client.new.today(address:)
    end
  end

  def air_quality(aq_val)
    aq_map = {
      1 => "Good",
      2 => "Moderate",
      3 => "Unhealthy for sensitive groups",
      4 => "Unhealthy",
      5 => "Very Unhealthy",
      6 => "Hazardous"
    }
    aq_map[aq_val] || "Unknown"
  end
end
