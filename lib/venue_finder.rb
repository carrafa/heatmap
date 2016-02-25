require 'httparty'
require 'json'

CLIENT_ID = ENV['client_id'] 
CLIENT_SECRET = ENV['client_secret']

def get_venues(search, ll)
  venues = []
  offset = 0
  while offset < 250 do
    venues << venue_search(search, ll, offset)
    offset = offset + 50
  end
  venues.flatten!
  return venues.to_json
end
  
def venue_search(search, ll, offset)
  response = HTTParty.get("https://api.foursquare.com/v2/venues/explore?client_id=#{CLIENT_ID}&client_secret=#{CLIENT_SECRET}&v=20130815&ll=#{ll}&query=#{search}&limit=50&offset=#{offset}&radius=8000")
  venues = response['response']['groups'][0]['items']
  return venues
end
