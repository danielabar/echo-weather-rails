class WeatherController < ApplicationController
  def index; end

  def search
    result = SearchWeather.call(address: params[:address])

    if result.success?
      @weather_current = result.weather_current
      @cached_message = "Cached results" if result.from_cache
    else
      flash.now[:message] = result.error
    end

    render :index
  end
end
