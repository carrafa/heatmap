require 'httparty'
require 'json'

CLIENT_ID = ENV['client_id'] 
CLIENT_SECRET = ENV['client_secret']

def get_venues(search, ll)
  venues = []
  offset = 0
  response = venue_search(search, ll, offset)
  venues << response[:venues]
  max = response[:max]
  offset = offset + 50
  while offset < max do
    response = venue_search(search, ll, offset)
    venues << response[:venues]
    offset = offset + 50
  end
  venues.flatten!
  return venues.to_json
end
  
def venue_search(search, ll, offset)
  foursquare = HTTParty.get("https://api.foursquare.com/v2/venues/explore?client_id=#{CLIENT_ID}&client_secret=#{CLIENT_SECRET}&v=20130815&ll=#{ll}&query=#{search}&limit=50&offset=#{offset}&radius=8000")
  response = {}
  response[:max] = foursquare['response']['totalResults']
  response[:venues] = foursquare['response']['groups'][0]['items']
  return response
end

# ----------- to return just lat lng instead of the whole venue object ------------
def ll_extractor(venues)
  ll_array = []
  venues.each do |venue|
    ll = []
    ll << venue['location']['lat']
    ll << venue['location']['lng']
    ll_array << ll
  end
  return ll_array
end
