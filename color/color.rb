require 'rubygems'
require 'bundler'
require 'json'
Bundler.require

$stdout.sync = true

ALIVE = true

Signal.trap("TERM") do
  puts "Caught a TERM signal.  Sleeping for 3 seconds and shutting down."
  sleep 3
  exit
end

class Color < Sinatra::Base
  def color
    ENV['COLOR'] || 'UNKNOWN.  Please set the $COLOR environment variable.'
  end

  get '/' do
    return JSON.dump({color: color})
  end

  get '/env' do
    return JSON.dump(ENV)
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
    sleep(10) and return "Slept for 10 seconds"
  end

  get '/hang' do
    ::ALIVE = false
  end

  private
end

printf "Starting up."
ENV.fetch('STARTUP_DELAY', 0).to_i.times do |n|
  printf "."
  sleep 1
end
puts

Thread.new do
  puts "We're alive!"
  while ::ALIVE do
    sleep 1
    File.write("/tmp/heartbeat", "alive")
  end
  puts "We're hung :("
  FileUtils.rm_rf("/tmp/heartbeat")
end

Color.run!(show_exceptions: false,
           raise_errors: true,
           traps: false,
           bind: '0.0.0.0',
           port: 80)
