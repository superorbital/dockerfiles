require 'rubygems'
require 'bundler'
require 'json'
Bundler.require

$stdout.sync = true

Signal.trap("TERM") do
  puts "Caught a TERM signal.  Sleeping for 3 seconds and shutting down."
  sleep 3
  exit
end

class Color < Sinatra::Base
  puts "My pid is #{Process.pid}"

  get '/' do
    output = {color: "unknown"}
    return JSON.dump(output)
  end

  get '/env' do
    `env | sort`
  end

  get '/disk' do
    `df -h`
  end

  get '/memory' do
    `free -m`
  end

  get '/exit' do
    puts "Received request for /exit. Terminating."
    File.open("/dev/termination-log", 'w') do |f| 
      f.write("Received request for /exit. Terminating.") 
    end
    Process.kill('TERM', Process.pid)
    return "Received request for /exit.  Terminating."
  end

  get '/sleep' do
    sleep 10
    "Slept for 10 seconds"
  end

  private
end

Color.run!(show_exceptions: false, 
           raise_errors: true, 
           traps: false, 
           bind: '0.0.0.0', 
           port: 80)

