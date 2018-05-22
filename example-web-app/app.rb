class App < Sinatra::Base
  set :bind, '0.0.0.0'

  configure do
    enable :logging
  end

  get '/' do
    str = "Hello!  I'm:"
    str += "  version: #{version}"  if version
    str += "  pod:     #{pod}"      if pod
    str += "  address: #{address}"  if address
    str += "  node:    #{node}"     if node
    return str
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
    Process.kill('TERM', Process.pid)
  end

  get '/fail' do
    Process.kill('KILL', Process.pid)
  end

  get '/sleep' do
    sleep 10
    "Slept for 10 seconds"
  end

  def version
    "v" + File.read('VERSION').chomp
  end

  def node
    ENV["MY_NODE_NAME"]     # gke-lab-default-pool-125fa189-sw7x
  end

  def pod
    ENV["MY_POD_NAME"]      # example-web-app-59dd6b459f-q29qp
  end
  
  def namespace
    ENV["MY_POD_NAMESPACE"] # default
  end

  def address
    ENV["MY_POD_IP"]        # 10.28.0.19
  end
end
