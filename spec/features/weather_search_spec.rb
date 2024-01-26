require "rails_helper"

describe "Weather Search" do
  let(:weather_response) { build(:weather_response) }

  it "user searches for weather" do
    weather_client_instance = instance_double(Weather::Client)
    allow(Weather::Client).to receive(:new).and_return(weather_client_instance)
    allow(weather_client_instance).to receive(:today).and_return(weather_response)

    visit root_path

    fill_in "address", with: "paris"
    click_on "Get Forecast"

    expect(page).to have_content("Current weather for Paris, Ile-de-France, France")
    expect(page).to have_content("Temperature: 11.0°C / 51.8°F")
    expect(page).to have_content("Condition: Partly cloudy")
    expect(page).to have_content("Air Quality: Good")
  end
end
