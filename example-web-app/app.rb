require 'sinatra'
require 'sinatra/base'

class App < Sinatra::Base
  set :bind, '0.0.0.0'

  configure do
    enable :logging
  end

  get '/' do
    '<h1>Hello!</h1>'
  end

  get '/env' do
    '<ul>' + ENV.each.map { |k, v| "<li><b>#{k}:</b> #{v}</li>" }.join + '</ul>'
  end

  get '/disk' do
    "<strong>Disk:</strong><br/><pre>#{`df -h`}</pre>"
  end

  get '/memory' do
    "<strong>Memory:</strong><br/><pre>#{`free -m`}</pre>"
  end

  get '/exit' do
    Process.kill('TERM', Process.pid)
  end

  get '/fail' do
    Process.kill('KILL', Process.pid)
  end

  get '/sleep' do
    sleep 10
    "Slept for 10 seconds"
  end
end
