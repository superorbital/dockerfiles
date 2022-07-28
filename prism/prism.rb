#!/usr/bin/env ruby

require 'rubygems'
require 'bundler'
require 'json'
require 'logger'
require 'open-uri'
Bundler.require

begin
  $stdout.sync = true
  $stderr.sync = true

  class Prism < Sinatra::Base
    not_found { "Path #{request.path} is unknown." }

    get '/' do
      return "ERROR: Please request /red, /blue, etc instead.\n"
    end

    get '/headers' do
      return JSON.pretty_generate(request_headers.to_h) + "\n"
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
        body = JSON.pretty_generate({"error": response.body, "code": response.code}) + "\n"
        return [500, body]
      end
    rescue StandardError => e
      body = JSON.pretty_generate({"error": e.message}) + "\n"
      return [500, body]
    end

    get "/*" do |color|
      puts "Proxying to #{color}"
      response = get("http://#{color}")
      if response.code == 200
        return response.body.chomp + "\n"
      else
        payload = json_or_string(response.body)
        body = JSON.pretty_generate({"error": payload, "code": response.code}) + "\n"
        return [500, body]
      end
    rescue StandardError => e
      body = JSON.pretty_generate({"error": e.message}) + "\n"
      return [500, body]
    end

    private

    def get(url)
      HTTParty.get(url, timeout: timeout, headers: istio_trace_headers_from_request)
    end

    def timeout
      ENV.fetch("TIMEOUT", 3)
    end

    def json_or_string(value)
      JSON.parse(value)
    rescue JSON::ParserError
      value
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

    def request_headers
      env.select { |k,v| k.start_with? 'HTTP_'}.
        transform_keys { |k| k.sub(/^HTTP_/, '').split('_').map(&:capitalize).join('-') }
    end

  end

  Prism.run!(show_exceptions: false,
             raise_errors: true,
             traps: false,
             bind: '0.0.0.0',
             port: 80)
rescue StandardError => e
  File.write("/dev/termination-log", e.to_s)
  exit 2
end
