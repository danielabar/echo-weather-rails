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
    Weather::Current.new(
      temperature_celsius: @forecast["current"]["temp_c"].to_f,
      condition: @forecast["current"]["condition"]["text"],
      air_quality: air_quality(@forecast["current"]["air_quality"]["us-epa-index"]),
      icon: @forecast["current"]["condition"]["icon"]
    )
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
