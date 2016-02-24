require 'dotenv'
Dotenv.load
require 'cuba'
require 'cuba/haml'
require 'cuba/sass'
require './venue_finder.rb'

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

    on "search", param("search")  do |search|
      venues = get_venues search
      res.headers["Content-Type"] = "application/json; charset=utf-8"
      res.write venues
    end

  end

end
