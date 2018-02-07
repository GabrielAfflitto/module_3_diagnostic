require 'rails_helper'

describe "When a user visits the root page" do
  it "should allow the user to search by a zipcode" do
    visit root_path

    fill_in "q", with: "80203"
    click_on "Locate"

    expect(current_path).to eq(search_path)

    conn = Faraday.new(url: "https://developer.nrel.gov/api/alt-fuel-stations/v1") do |faraday|
      faraday.headers['x-api-key'] = ENV["API_KEY"]
      faraday.headers['Accept'] = 'application/json'
      faraday.adapter    Faraday.default_adapter
    end

    response = conn.get("nearest?&location=80203&fuel_type=ELEC&LPG&limit=10")
    stations = JSON.parse(response.body, symbolize_names: true)
    # binding.pry
    expect(stations[:fuel_stations].count).to eq(10)
    expect(page).to have_content("ELEC" || "LPG")
    # expect(page).to have_content("LPG")
    expect(page).to_not have_content("E85")
    expect(page).to_not have_content("BD")
    expect(page).to_not have_content("CNG")
    expect(page).to_not have_content("HY")

    within ".stations" do
      expect(page).to have_content(stations[:fuel_stations].first[:station_name])
      expect(page).to have_content(stations[:fuel_stations].first[:street_address])
      expect(page).to have_content(stations[:fuel_stations].first[:fuel_type_code])
      expect(page).to have_content(stations[:fuel_stations].first[:distance])
      expect(page).to have_content(stations[:fuel_stations].first[:access_days_time])
    end
  end
end

# As a user
# When I visit "/"
# And I fill in the search form with 80203
# And I click "Locate"
# Then I should be on page "/search" with parameters visible in the url
# Then I should see a list of the 10 closest stations within 6 miles sorted by distance
# And the stations should be limited to Electric and Propane
# And for each of the stations I should see Name, Address, Fuel Types, Distance, and Access Times
