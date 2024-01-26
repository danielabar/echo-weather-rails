require "rails_helper"

describe SearchWeather do
  let(:weather_response) { build(:weather_response) }

  describe ".call" do
    subject(:result) { described_class.call(context) }

    let(:address) { "Paris" }
    let(:context) { Interactor::Context.new(address:) }

    it "fetches and builds the current weather data" do
      weather_client_instance = instance_double(Weather::Client)
      allow(Weather::Client).to receive(:new).and_return(weather_client_instance)
      allow(weather_client_instance).to receive(:today).and_return(weather_response)

      expect(result).to be_a_success
      expect(result.from_cache).to be_falsey
      expect(result.weather_current).to be_a(Weather::Current)
      expect(result.weather_current).to have_attributes(
        temperature_celsius: 11.0,
        condition: "Partly cloudy",
        air_quality: "Good",
        icon: "//cdn.weatherapi.com/weather/64x64/night/116.png",
        location_name: "Paris",
        region: "Ile-de-France",
        country: "France"
      )
    end

    it "caches subsequent call" do
      weather_client_instance = instance_double(Weather::Client)
      allow(Weather::Client).to receive(:new).and_return(weather_client_instance)
      allow(weather_client_instance).to receive(:today).and_return(weather_response)
      expect(weather_client_instance).to receive(:today).once.with(city: "Paris")

      Rails.cache.with_local_cache do
        result1 = described_class.call(address: "Paris")
        expect(result1.from_cache).to be_falsey

        result2 = described_class.call(address: "Paris")
        expect(result2.from_cache).to be_truthy
      end
    end

    it "fails when Weather::ApiError is raised" do
      weather_error = Weather::ApiError.new(404, "City not found")
      weather_client_instance = instance_double(Weather::Client)
      allow(Weather::Client).to receive(:new).and_return(weather_client_instance)
      allow(weather_client_instance).to receive(:today).and_raise(weather_error)

      expect(result).to be_a_failure
      expect(result.error).to eq("Weather API Error: City not found")
    end
  end
end