# app/controllers/weather_controller.rb
class WeatherController < ApplicationController
  def index; end

  def search
    result = SearchWeather.call(address: params[:address])

    if result.success?
      @weather_current = result.weather_current
    else
      flash.now[:message] = result.error
    end

    render :index
  end
end
