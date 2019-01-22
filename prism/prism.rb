require 'rubygems'
require 'bundler'
require 'json'
require 'logger'
require 'open-uri'
Bundler.require

$stdout.sync = true
$stderr.sync = true

class Prism < Sinatra::Base
  get '/' do
    return "ERROR: Please request /color/red, /color/blue, etc instead.\n"
  end

  get "/egress" do
    puts "Requesting external URL"
    response = HTTParty.get("http://api.ipify.org?format=json", timeout: ENV.fetch("TIMEOUT", 3))
    if response.code == 200
      return response.body.chomp + "\n"
    else
      return JSON.pretty_generate({"error": response.body, "code": response.code}) + "\n"
    end
  end

  get "/:color" do
    color = params[:color]
    puts "Proxying to #{params[:color]}"
    response = HTTParty.get("http://#{color}", timeout: ENV.fetch("TIMEOUT", 3))
    if response.code == 200
      return response.body.chomp + "\n"
    else
      return JSON.pretty_generate({"error": response.body, "code": response.code}) + "\n"
    end
  rescue StandardError => e
    return JSON.pretty_generate({"error": e.message}) + "\n"
  end
end

Prism.run!(show_exceptions: false,
           raise_errors: true,
           traps: false,
           bind: '0.0.0.0',
           port: 80)
