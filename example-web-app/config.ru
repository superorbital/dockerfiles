require 'rubygems'
require 'bundler'
Bundler.require

at_exit do
  puts 'App exited gracefully'
  exit false
end

require './app'
run App
