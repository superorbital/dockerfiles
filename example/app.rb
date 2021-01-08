require 'rubygems'
require 'bundler'
Bundler.require

$stdout.sync = true

Signal.trap("TERM") do
  puts "Caught a TERM signal.  Sleeping for 3 seconds and shutting down."
  sleep 3
  exit
end

class App < Sinatra::Base
  puts "My pid is #{Process.pid}"

  get '/' do
    output = ["Hello!  I'm:"]
    output.push "  version: #{version}"  if version
    output.push "  pod:     #{pod}"      if pod
    output.push "  address: #{address}"  if address
    output.push "  node:    #{node}"     if node
    output.push ""
    return output.join("\n")
  end

  get '/env' do
    `env | sort`
  end

  get '/files' do
    `grep "" /config/*`
  end

  get '/disk' do
    `df -h`
  end

  get '/memory' do
    `free -m`
  end

  get '/exit' do
    puts "Gaaaaahhhh!  Someone hit /exit!"
    File.open("/dev/termination-log", 'w') do |f|
      f.write("Gaaaaahhhh!  Someone hit /exit!")
    end
    Process.kill('TERM', Process.pid)
    return "Gaaaaaah!\n"
  end

  get '/sleep' do
    sleep 10
    "Slept for 10 seconds"
  end

  private

  def version
    "v" + File.read('VERSION').chomp
  end

  def node
    ENV["MY_NODE_NAME"]
  end

  def pod
    ENV["MY_POD_NAME"]
  end

  def namespace
    ENV["MY_POD_NAMESPACE"]
  end

  def address
    ENV["MY_POD_IP"]
  end
end

App.run! show_exceptions: false, raise_errors: true, traps: false, bind: '0.0.0.0', port: 5000
