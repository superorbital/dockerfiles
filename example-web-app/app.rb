require 'sinatra'
require 'sinatra/base'

class App < Sinatra::Base
  set :bind, '0.0.0.0'

  configure do
    enable :logging
  end

  get '/' do
    "Hello."
  end

  get '/env' do
    `env`
  end

  get '/disk' do
    `df -h`
  end

  get '/memory' do
    `free -m`
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
