require 'rubygems'
require 'bundler'
require 'json'
require 'logger'
require 'open-uri'
Bundler.require

$stdout.sync = true
$stderr.sync = true

ALIVE = true

Signal.trap("TERM") do
  puts "Caught a TERM signal.  Sleeping for 3 seconds and shutting down."
  sleep 3
  exit 3
end

COLORS=%w(
  red
  orange
  yellow
  green
  blue
  purple
  brown
  magenta
  tan
  cyan
  olive
  maroon
  navy
  aquamarine
  turquoise
  silver
  lime
  teal
  indigo
  violet
  pink
  black
  white
  gray
)

class Prism < Sinatra::Base
  get '/' do
    return "ERROR: Please request /red, /blue, etc instead.\n"
  end

  COLORS.each do |color|
    get "/#{color}" do
      response = HTTParty.get("http://#{color}", timeout: 5)
      if response.code == 200
        return response.body
      else
        return JSON.pretty_generate({"error": response.body, "code": response.code}) + "\n"
      end
    rescue StandardError => e
      return JSON.pretty_generate({"error": e.message}) + "\n"
    end
  end
end

Prism.run!(show_exceptions: false,
           raise_errors: true,
           traps: false,
           bind: '0.0.0.0',
           port: 80)
