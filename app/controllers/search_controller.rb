class SearchController < ApplicationController

  def index
    @conn = Faraday.new(url: "https://developer.nrel.gov/api/alt-fuel-stations/v1") do |faraday|
      faraday.headers['x-api-key'] = ENV["API_KEY"]
      faraday.headers['Accept'] = 'application/json'
      faraday.adapter    Faraday.default_adapter
    end
    response = @conn.get("nearest?&location=80203&fuel_type=ELEC&LPG&sort:distance&limit=10")
    stations = JSON.parse(response.body, symbolize_names: true)
    @search = stations[:fuel_stations]
    # binding.pry
  end

end
