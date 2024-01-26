# Echo Weather Rails

Echo Weather Rails is a Ruby on Rails application designed to display current weather information using the [Weather Api](https://www.weatherapi.com/docs/). This project incorporates various technical concepts such as Rails controllers, service objects (Interactors), and a custom client to interact with the Weather API.

## Getting Started

To set up and run the application, follow these steps to install the necessary dependencies, set up the database, and start the development server:

```bash
# Start the Postgres database in a container
docker-compose up

# Install dependencies and prepare database
bin/setup

# Enable dev caching
bin/rails dev:cache

# Start the Rails dev server and TailwindCSS build
bin/dev
```

## Database Initialization

Although the project is set up to use a PostgreSQL database, it is currently not utilized as all the weather data is fetched directly from the Weather API. The database is initialized to handle potential future requirements, such as implementing user logins. In the future, users could save their frequently accessed weather locations or perform other data-related tasks.

If you have specific database-related needs or plan to extend the project with user-specific features, you can explore and leverage the PostgreSQL database setup already in place.

## Configuration

### Weather API Key

To get started with the Echo Weather Rails application, you need to obtain an API key from [Weather Api](https://www.weatherapi.com/docs/). Follow these steps:

1. Visit [Weather Api Sign Up](https://www.weatherapi.com/signup.aspx) to create an account.
2. After signing up, you will receive an API key. Copy this key as you'll need it for the next step.

### Setting Up Environment Variables

The application relies on environment variables to securely store sensitive information like API keys. A template file `env.template` is provided. Follow these steps to set up your environment variables:

1. Copy the `env.template` file to a new file named `.env`.

   ```bash
   cp env.template .env
   ```

2. Open the .env file in a text editor.
3. Replace the placeholder fill_me_in in the WEATHER_API_KEY variable with the API key you obtained from Weather Api.

## Usage

Once the application is running, you can access the weather information by navigating to the root URL. Additionally, there is a search feature available at `/weather/search` where you can input a specific address to retrieve the current weather details.

## Routes

The application's routes are defined as follows:

```ruby
Rails.application.routes.draw do
  root "weather#index"
  get "weather/search", to: "weather#search", as: "weather_search"
end
```

## Weather Controller

The `WeatherController` handles the rendering of the weather information. The `index` action displays the default view, while the `search` action utilizes the `SearchWeather` Interactor to fetch and display weather details based on a user-provided address.

## SearchWeather Interactor

The `SearchWeather` Interactor encapsulates the logic for fetching weather data from the Weather API. It includes error handling for potential API errors and utilizes caching to improve performance. The retrieved data is then structured into a `Weather::Current` model for easy display in the UI.

## Weather::Client

The `Weather::Client` is a custom client responsible for interacting with the Weather API. It handles API requests, error handling, and logging. The client is configured with the API URL and key from environment variables.

## Weather::Current Model

The `Weather::Current` model is designed to collect and structure the Weather API data for easy integration into the UI. It includes attributes such as temperature, condition, air quality, and location details.

Feel free to explore and extend this project to suit your specific needs or integrate additional features. If you encounter any issues, refer to the documentation of the [Weather Api](https://www.weatherapi.com/docs/) or review the relevant sections in this README for troubleshooting.

## Deployment Instructions

When deploying this application to a production environment, it's important to configure caching for optimal performance. The current implementation relies on Rails caching, which is suitable for development. However, for production deployments, consider setting up Redis or Memcached to handle caching requirements efficiently.

To configure caching for production:

1. Install and configure Redis or Memcached on your production server.
2. Update the caching configuration in the `config/environments/production.rb` file to use your chosen caching solution.

   Example for Redis:

   ```ruby
   config.cache_store = :redis_cache_store, { url: ENV['REDIS_URL'] }
   ```

   Example for Memcached:

   ```ruby
   config.cache_store = :mem_cache_store, ENV['MEMCACHED_SERVERS'].split(',')
   ```

   Replace `ENV['REDIS_URL']` or `ENV['MEMCACHED_SERVERS']` with the appropriate environment variables containing your Redis or Memcached configuration.

3. Ensure that the chosen caching service is running and accessible from your production environment.

By configuring an efficient caching solution in production, you can enhance the application's performance and responsiveness.
