module Weather
  class Current
    include ActiveModel::Model

    attr_accessor :temperature_celsius, :condition, :air_quality, :icon, :location_name, :region, :country
  end
end
