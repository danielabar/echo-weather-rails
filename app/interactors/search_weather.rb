# app/interactors/search_weather.rb
class SearchWeather
  include Interactor

  def call
    address = context.address
    # TODO: Check if address is in cache before fetching it again from api
    forecast = fetch_forecast(address)

    context.weather_current = build_weather_current(forecast)
  end

  private

  def build_weather_current(forecast)
    current_data = forecast["current"]
    location_data = forecast["location"]
    Weather::Current.new(
      temperature_celsius: extract_temperature(current_data),
      condition: extract_condition(current_data),
      air_quality: air_quality(current_data["air_quality"]["us-epa-index"]),
      icon: current_data["condition"]["icon"],
      location_name: location_data["name"],
      region: location_data["region"],
      country: location_data["country"]
    )
  end

  def extract_temperature(data)
    data["temp_c"].to_f
  end

  def extract_condition(data)
    data["condition"]["text"]
  end

  def fetch_forecast(address)
    weather_client = Weather::Client.new
    weather_client.today(city: address)
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