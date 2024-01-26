require "rails_helper"

# Reference: https://danielabaron.me/blog/testing-faraday-with-rspec/
describe Weather::Client do
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:conn) { Faraday.new { |b| b.adapter(:test, stubs) } }
  let(:client) { described_class.new(conn) }
  let(:paris_weather) { build(:weather_response) }

  after do
    Faraday.default_connection = nil
  end

  describe "#today" do
    it "gets current weather for a city" do
      stubs.get("current.json") do
        [
          200,
          { "Content-Type": "application/json" },
          paris_weather.to_json
        ]
      end

      response = client.today(city: "Paris")
      expect(response).to eq(paris_weather)
      stubs.verify_stubbed_calls
    end

    it "handles 400 error when no matching location found" do
      error_response = { "error" => { "code" => 1006, "message" => "No matching location found." } }

      stubs.get("current.json") do
        [
          400,
          { "Content-Type": "application/json" },
          error_response.to_json
        ]
      end

      expect do
        client.today(city: "InvalidCity")
      end.to raise_error(Weather::ApiError, "No matching location found.")
      stubs.verify_stubbed_calls
    end

    it "handles 400 error with JSON parsing error" do
      invalid_json_response = "Invalid JSON response"

      stubs.get("current.json") do
        [
          400,
          { "Content-Type": "application/json" },
          invalid_json_response
        ]
      end

      expect do
        client.today(city: "InvalidCity")
      end.to raise_error(Weather::ApiError, "Unexpected API error format.")
      stubs.verify_stubbed_calls
    end

    it "handles 500 server error" do
      server_error_response = { "error" => { "code" => 500, "message" => "Internal server error." } }

      stubs.get("current.json") do
        [
          500,
          { "Content-Type": "application/json" },
          server_error_response.to_json
        ]
      end

      expect { client.today(city: "ServerIssueCity") }.to raise_error(Weather::ApiError, "Server error occurred.")
      stubs.verify_stubbed_calls
    end
  end
end
