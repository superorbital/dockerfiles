require 'rubygems'
require 'bundler'
require 'json'
require 'logger'
Bundler.require

$stdout.sync = true
$stderr.sync = true

ALIVE = true

begin
  Signal.trap("TERM") do
    puts "Caught a TERM signal.  Sleeping for 3 seconds and shutting down."
    sleep 3
    exit 3
  end

  class Color < Sinatra::Base
    def color
      ENV['COLOR'] || 'UNKNOWN.  Please set the $COLOR environment variable.'
    end

    if ENV['LOGFILE']
      log = File.new(ENV['LOGFILE'], "a+")
      $stdout.reopen(log)
      $stderr.reopen(log)
      $stderr.sync = true
      $stdout.sync = true
    end

    get '/' do
      return JSON.dump({color: color}) + "\n"
    end

    get '/env' do
      return JSON.pretty_generate(ENV.to_h) + "\n"
    end

    get '/ping' do
      ping = ::Net::Ping::External.new('8.8.8.8').ping?
      return JSON.dump({can_ping: ping}) + "\n"
    end

    get '/whoami' do
      return "Your IP appears to be #{request.ip}"
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
      "Hanging..."
    end
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
rescue StandardError => e
  File.write("/dev/termination-log", e.to_s)
  exit 2
end
