require 'rails_helper'

describe "When a user visits the root page" do
  it "should allow the user to search by a zipcode" do
    visit root_path

    # save_and_open_page
    fill_in "q", with: "80203"
    click_on "Locate"

    conn = Faraday.new(url: "https://developer.nrel.gov/api/alt-fuel-stations/v1/nearest.json?") do |faraday|
      faraday.headers['api_key'] = ENV["API_KEY"]
      faraday.adapter Faraday.default_adapter
    end

    response = conn.get("/location=80203&fuel_type=ELEC&LPG")
    stations = JSON.parse(response.body)

    expect(current_path).to eq(search_path)
    # expect(page).to have_content
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
