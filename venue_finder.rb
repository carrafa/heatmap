require 'httparty'
require 'json'

CLIENT_ID = ENV['client_id'] 
CLIENT_SECRET = ENV['client_secret']

def get_venues(search, ll)
  venues = []
  ll_array = get_lls(ll, 0.1)
  ll_array.each do |latLng|
    venues << venue_search(search, latLng)
  end
  venues.flatten!
  return venues.to_json
end
  

def venue_search(search, ll)
  response = HTTParty.get("https://api.foursquare.com/v2/venues/search?client_id=#{CLIENT_ID}&client_secret=#{CLIENT_SECRET}&v=20130815&ll=#{ll}&query=#{search}&limit=50")
  venues = response['response']['venues']
  return venues
end


def ll_mover(latLng, offset_1, offset_2)
  ll_array = latLng.split(",").map{|s| s.to_f}
  ll_array[0] = ll_array[0] + offset_1
  ll_array[1] = ll_array[1] + offset_2
  return ll_array.join(",").to_s
end

def get_lls(latLng, offset)
  lls = []
  lls << ll_mover( latLng, offset, offset )
  lls << ll_mover( latLng, offset * -1, offset )
  lls << ll_mover( latLng, offset, offset * -1 )
  lls << ll_mover( latLng, offset * -1, offset * -1 )
  lls << ll_mover( latLng, offset* 0 , offset* 0 )
  return lls
end
