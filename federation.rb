require 'sinatra'
require "bundler/setup"
require 'diaspora_federation'
require "nokogiri"
require 'open-uri'
require "erb"
require "rest-client"
require "./features/support/config"
require "./features/support/test_data"

set :bind, "0.0.0.0"

#routes

get '/.well-known/host-meta' do
  hostmeta = DiasporaFederation::Discovery::HostMeta.from_base_url(Config.instance.testbed_url)
  hostmeta.to_xml
end

get '/' do
  erb :index
end

get '/webfinger' do
  id = params[:q].match(/acct:([^\&]+)/)[1]
  user = GeneratedData.instance.find_by_id_or_create(id)
	wf = DiasporaFederation::Discovery::WebFinger.new({
    acct_uri:    user.id,
    alias_url:   "#{Config.instance.testbed_url}/people/#{user.guid}",
    hcard_url:   "#{Config.instance.testbed_url}/hcard/users/#{id}",
    seed_url:    "#{Config.instance.testbed_url}/",
    profile_url: "#{Config.instance.testbed_url}/",
    atom_url:    "#{Config.instance.testbed_url}/public/user.atom",
    salmon_url:  "#{Config.instance.testbed_url}/receive/users/#{user.guid}",
    guid:        user.guid,
    public_key:  user.public_key
  })
  wf.to_xml
end

get '/hcard/users/:id' do |id|
  user = GeneratedData.instance.find_by_id_or_create(id)
  hcard = DiasporaFederation::Discovery::HCard.new({
    guid:             user.guid,
    diaspora_handle:  user.id,
    full_name:        user.username,
    url:              "#{Config.instance.testbed_url}/",
    photo_large_url:  "#{Config.instance.testbed_url}/profile.jpg",
    photo_medium_url: "#{Config.instance.testbed_url}/profile.jpg",
    photo_small_url:  "#{Config.instance.testbed_url}/profile.jpg",
    public_key:       user.public_key,
    searchable:       true,
    first_name:       user.username,
    last_name:        user.last_name,
    nickname:         user.username,
  })
  html_string = hcard.to_html
end

post '/' do
  erb :index
end

get '/public/user.atom'  do
  @doc = Nokogiri::XML(open('https://joindiaspora.com/public/carolinagc.atom'))
  @post_title = @doc.xpath('//xmlns:title')

  builder :feed
end

get "/people/:guid/stream" do |guid|
  [].to_json
end
