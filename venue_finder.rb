require 'httparty'
require 'json'

CLIENT_ID = ENV['client_id'] 
CLIENT_SECRET = ENV['client_secret']

def get_venues(search, ll)
  response = HTTParty.get("https://api.foursquare.com/v2/venues/search?client_id=#{CLIENT_ID}&client_secret=#{CLIENT_SECRET}&v=20130815&ll=#{ll}&query=#{search}&limit=50")
  venues = response['response']['venues']
  return venues.to_json
end

