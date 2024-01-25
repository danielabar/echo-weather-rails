class WeatherController < ApplicationController
  def index; end

  def search
    @address = params[:address]
    @forecast = fetch_forecast(@address)
    Rails.logger.debug { "Forecast for #{@address}: #{@forecast}" }

    @weather_current = build_weather_current
    render :index
  end

  private

  def build_weather_current
    current_data = @forecast["current"]
    location_data = @forecast["location"]

    Weather::Current.new(
      temperature_celsius: extract_temperature(current_data),
      condition: extract_condition(current_data),
      air_quality: air_quality(current_data["air_quality"]["us-epa-index"]),
      icon: current_data["condition"]["icon"],
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
