#!/usr/bin/env ruby

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
    return "ERROR: Please request /red, /blue, etc instead.\n"
  end

  get "/healthz" do
    return JSON.pretty_generate({"health": "good"}) + "\n"
  end

  get '/version' do
    return JSON.dump({version: File.read('VERSION').chomp}) + "\n"
  end

  get "/egress" do
    puts "Requesting external URL"
    response = get("http://api.ipify.org?format=json")
    if response.code == 200
      return response.body.chomp + "\n"
    else
      return JSON.pretty_generate({"error": response.body, "code": response.code}) + "\n"
    end
  rescue StandardError => e
    return JSON.pretty_generate({"error": e.message}) + "\n"
  end

  get "/*" do |color|
    puts "Proxying to #{color}"
    response = get("http://#{color}")
    if response.code == 200
      return response.body.chomp + "\n"
    else
      return JSON.pretty_generate({"error": response.body, "code": response.code}) + "\n"
    end
  rescue StandardError => e
    return JSON.pretty_generate({"error": e.message}) + "\n"
  end

  private

  def get(url)
    HTTParty.get(url, timeout: timeout, headers: istio_trace_headers_from_request)
  end

  def timeout
    ENV.fetch("TIMEOUT", 3)
  end

  def istio_trace_headers_from_request
    names = %w(
      x-request-id
      x-b3-traceid
      x-b3-spanid
      x-b3-parentspanid
      x-b3-sampled
      x-b3-flags
      x-ot-span-context
    )

    Hash[names.map { |name| [name, request_header(name)]}]
  end

  def request_header(name)
    rackified_name = "HTTP_" + name.tr('-', '_').upcase
    env[rackified_name]
  end

end

Prism.run!(show_exceptions: false,
           raise_errors: true,
           traps: false,
           bind: '0.0.0.0',
           port: 80)
