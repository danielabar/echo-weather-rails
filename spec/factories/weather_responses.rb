FactoryBot.define do
  factory :weather_response, class: "String" do
    skip_create
    location do
      {
        "name" => "Paris",
        "region" => "Ile-de-France",
        "country" => "France",
        "lat" => 48.87,
        "lon" => 2.33,
        "tz_id" => "Europe/Paris",
        "localtime_epoch" => 1_706_221_349,
        "localtime" => "2024-01-25 23:22"
      }
    end

    current do
      {
        "last_updated_epoch" => 1_706_220_900,
        "last_updated" => "2024-01-25 23:15",
        "temp_c" => 11.0,
        "temp_f" => 51.8,
        "is_day" => 0,
        "condition" => {
          "text" => "Partly cloudy",
          "icon" => "//cdn.weatherapi.com/weather/64x64/night/116.png",
          "code" => 1003
        },
        "wind_mph" => 8.1,
        "wind_kph" => 13.0,
        "wind_degree" => 230,
        "wind_dir" => "SW",
        "pressure_mb" => 1028.0,
        "pressure_in" => 30.36,
        "precip_mm" => 0.01,
        "precip_in" => 0.0,
        "humidity" => 94,
        "cloud" => 75,
        "feelslike_c" => 9.8,
        "feelslike_f" => 49.7,
        "vis_km" => 10.0,
        "vis_miles" => 6.0,
        "uv" => 1.0,
        "gust_mph" => 10.5,
        "gust_kph" => 16.9,
        "air_quality" => {
          "co" => 340.5,
          "no2" => 16.6,
          "o3" => 33.6,
          "so2" => 2.7,
          "pm2_5" => 5.4,
          "pm10" => 7.6,
          "us-epa-index" => 1,
          "gb-defra-index" => 1
        }
      }
    end

    initialize_with do
      {
        "location" => location,
        "current" => current
      }
    end
  end
end
