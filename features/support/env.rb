require 'diaspora_federation'
require 'rest_client'
require 'nokogiri'
require 'open-uri'
require 'yaml'

require "./features/support/config"
require "./features/support/test_data"

app_file = File.join(File.dirname(__FILE__), *%w[.. .. federation.rb])
require app_file
# Force the application name because polyglot breaks the auto-detection logic.
Sinatra::Application.app_file = app_file

@thread = Thread.new do
  Rack::Handler::WEBrick.run Sinatra::Application.new, :Port => 4567, :Host => "0.0.0.0"
end
sleep 1 # give the server time to fire up
