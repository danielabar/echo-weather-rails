# Echo Weather Rails

Display weather information using the [Weather Api](https://www.weatherapi.com/docs/).

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## Example Weather Response

```ruby
{"location"=>{"name"=>"Paris", "region"=>"Ile-de-France", "country"=>"France", "lat"=>48.87, "lon"=>2.33, "tz_id"=>"Europe/Paris", "localtime_epoch"=>1706148263, "localtime"=>"2024-01-25 3:04"},
 "current"=>
  {"last_updated_epoch"=>1706148000,
   "last_updated"=>"2024-01-25 03:00",
   "temp_c"=>10.0,
   "temp_f"=>50.0,
   "is_day"=>0,
   "condition"=>{"text"=>"Light rain", "icon"=>"//cdn.weatherapi.com/weather/64x64/night/296.png", "code"=>1183},
   "wind_mph"=>2.2,
   "wind_kph"=>3.6,
   "wind_degree"=>10,
   "wind_dir"=>"N",
   "pressure_mb"=>1032.0,
   "pressure_in"=>30.47,
   "precip_mm"=>0.01,
   "precip_in"=>0.0,
   "humidity"=>94,
   "cloud"=>75,
   "feelslike_c"=>9.4,
   "feelslike_f"=>49.0,
   "vis_km"=>10.0,
   "vis_miles"=>6.0,
   "uv"=>1.0,
   "gust_mph"=>6.3,
   "gust_kph"=>10.1,
   "air_quality"=>{"co"=>454.0, "no2"=>18.7, "o3"=>0.9, "so2"=>2.8, "pm2_5"=>11.7, "pm10"=>14.3, "us-epa-index"=>1, "gb-defra-index"=>1}}}
```
