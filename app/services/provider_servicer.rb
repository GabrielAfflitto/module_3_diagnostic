class ProviderServicer
  attr_reader :conn
  def initalize
    @conn = Faraday.new(url: "https://developer.nrel.gov/api/alt-fuel-stations/v1") do |faraday|
      faraday.headers['x-api-key'] = ENV["API_KEY"]
      faraday.headers['Accept'] = 'application/json'
      faraday.adapter    Faraday.default_adapter
    end
  end

  def alt_fuel
    response = @conn.get("nearest?&location=80203&fuel_type=ELEC&LPG&sort:distance&limit=10")
    # binding.pry
    b = JSON.parse(response.body, symbolize_names: true)
  end

end
