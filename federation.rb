require 'sinatra'
require "bundler/setup"
require 'diaspora_federation'
require "nokogiri"
require 'open-uri'
require "erb"
require "rest-client"

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
	wf = DiasporaFederation::Discovery::WebFinger.new({
		acct_uri:    GeneratedData.instance.test_user_id,
    alias_url:   "#{Config.instance.testbed_url}/people/#{GeneratedData.instance.guid}",
    hcard_url:   "#{Config.instance.testbed_url}/federation/hcard",
    seed_url:    "#{Config.instance.testbed_url}/",
    profile_url: "#{Config.instance.testbed_url}/",
    atom_url:    "#{Config.instance.testbed_url}/public/user.atom",
    salmon_url:  "#{Config.instance.testbed_url}/receive/users/#{GeneratedData.instance.guid}",
    guid:        GeneratedData.instance.guid,
    public_key:  GeneratedData.instance.public_key
  })
  wf.to_xml
end

get '/federation/hcard' do
  hcard = DiasporaFederation::Discovery::HCard.new({
    guid:             GeneratedData.instance.guid,
    diaspora_handle:  GeneratedData.instance.test_user_id,
    full_name:        GeneratedData.instance.test_user_name,
    url:              "#{Config.instance.testbed_url}/",
    photo_large_url:  "#{Config.instance.testbed_url}/profile.jpg",
    photo_medium_url: "#{Config.instance.testbed_url}/profile.jpg",
    photo_small_url:  "#{Config.instance.testbed_url}/profile.jpg",
    public_key:           GeneratedData.instance.public_key,
    searchable:       true,
    first_name:       GeneratedData.instance.test_user_name,
    last_name:        'foo',
    nickname:         GeneratedData.instance.test_user_name,
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
