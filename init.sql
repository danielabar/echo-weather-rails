-- Only used for development where Postgres is run in Docker
create role echo_weather_rails with CREATEDB login password 'echo_weather_rails';
