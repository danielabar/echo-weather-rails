require "rails_helper"

describe "Weather Search" do
  let(:weather_response) { build(:weather_response) }
  let(:weather_client_instance) { instance_double(Weather::Client) }

  before do
    allow(Weather::Client).to receive(:new).and_return(weather_client_instance)
    allow(weather_client_instance).to receive(:today).and_return(weather_response)
  end

  it "displays weather results from search and clears out on clicking New" do
    visit root_path

    fill_in "address", with: "paris"
    click_on "Get Forecast"

    expect(page).to have_content("Current weather for Paris, Ile-de-France, France")
    expect(page).to have_content("Temperature: 11.0°C / 51.8°F")
    expect(page).to have_content("Condition: Partly cloudy")
    expect(page).to have_content("Air Quality: Good")

    click_on "New Search"

    expect(page).to have_no_content("Current weather for Paris, Ile-de-France, France")

    expect(page).to have_field("address")
    expect(page).to have_button("Get Forecast")
  end

  it "displays an error message when no address provided" do
    visit root_path

    click_on "Get Forecast"

    expect(page).to have_content("Alert! Address must be provided")
  end
end
