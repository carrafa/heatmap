require 'httparty'
require 'json'

class Foursquare
  
  CLIENT_ID = ENV['client_id'] 
  CLIENT_SECRET = ENV['client_secret']

  attr_reader :search, :ll
  attr_accessor :offset, :radius, :venues

  def initialize(search, ll)
    @search = search
    @ll = ll
    @radius = '8000'
    @venues = []
    @offset = 0
  end

  def offset_incrementer
    @offset += 50
  end
  
  def get_venues
    
    response = venue_search
    venues << response['groups'][0]['items']
    max = response['totalResults']
    offset_incrementer

    while offset < max do
      response = venue_search
      venues << response['groups'][0]['items']
      offset_incrementer
    end

    venues.flatten!
    return venues.to_json 
  end

  def venue_search
    response = HTTParty.get("https://api.foursquare.com/v2/venues/explore?client_id=#{CLIENT_ID}&client_secret=#{CLIENT_SECRET}&v=20130815&ll=#{ll}&query=#{search}&limit=50&offset=#{offset}&radius=#{radius}")
    return response['response']
  end

end
