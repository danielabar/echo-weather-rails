# app/controllers/weather_controller.rb
class WeatherController < ApplicationController
  def index; end

  def search
    result = SearchWeather.call(address: params[:address])

    if result.success?
      @weather_current = result.weather_current
    else
      flash.now[:message] = "Failed to fetch weather data."
    end

    render :index
  end
end
