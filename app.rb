require 'cuba'
require 'cuba/haml'
require 'cuba/sass'
require 'dotenv'
Dotenv.load
require './lib/venue_finder.rb'

Cuba.plugin Cuba::Haml
Cuba.plugin Cuba::Sass

Cuba.use(
  Rack::Static,
  urls: %w(/js /stylesheets),
  root: "./public"
)

Cuba.settings[:sass] = {
  style: :compact,
  template_location: "assets/stylesheets"
}

Cuba.define do

  on get do

    on root do
      haml 'index'
    end

    on "search/:search/:ll" do |search, ll|

      venues = get_venues(search, ll)
      res.headers["Content-Type"] = "application/json; charset=utf-8"
      res.write venues

    end

  end

end
