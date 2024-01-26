require "rails_helper"

describe "Weather" do
  describe "GET /" do
    it "returns a successful response" do
      get root_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /weather/search" do
    let(:weather_response) { build(:weather_response) }

    it "returns a successful response" do
      weather_client_instance = instance_double(Weather::Client)
      allow(Weather::Client).to receive(:new).and_return(weather_client_instance)
      allow(weather_client_instance).to receive(:today).and_return(weather_response)

      get weather_search_path, params: { address: "paris", commit: "Get Forecast" }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Current weather for Paris, Ile-de-France, France")
    end

    it "displays an error message when address not provided" do
      get weather_search_path, params: { address: "", commit: "Get Forecast" }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Address must be provided")
    end
  end
end
