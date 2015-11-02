require 'sinatra'
require "bundler/setup"
require 'diaspora_federation'
require "nokogiri"
require 'open-uri'
require "erb"
require "rest-client"
require "federation-testbed/config"
require "federation-testbed/test_data"

module FederationTestbed
  def self.config
    FederationTestbed::Config.instance
  end

  def self.test_data
    FederationTestbed::GeneratedData.instance
  end
end

class FederationTestbed::App < Sinatra::Base
  set :bind, "0.0.0.0"

  attr_accessor :pulled_entities

  def initialize
    @pulled_entities = []
    super
  end

  def config
    FederationTestbed::Config.instance
  end

  def test_data
    FederationTestbed::GeneratedData.instance
  end

  #routes

  get '/.well-known/host-meta' do
    hostmeta = DiasporaFederation::Discovery::HostMeta.from_base_url(config.testbed_url)
    hostmeta.to_xml
  end

  get '/' do
    erb :index
  end

  get '/webfinger' do
    id = params[:q].match(/acct:([^\&]+)/)[1]
    user = test_data.find_by_id_or_create(id)
	  wf = DiasporaFederation::Discovery::WebFinger.new({
      acct_uri:    user.id,
      alias_url:   "#{config.testbed_url}/people/#{user.guid}",
      hcard_url:   "#{config.testbed_url}/hcard/users/#{id}",
      seed_url:    "#{config.testbed_url}/",
      profile_url: "#{config.testbed_url}/",
      atom_url:    "#{config.testbed_url}/public/user.atom",
      salmon_url:  "#{config.testbed_url}/receive/users/#{user.guid}",
      guid:        user.guid,
      public_key:  user.public_key
    })
    wf.to_xml
  end

  get '/hcard/users/:id' do |id|
    user = test_data.find_by_id_or_create(id)
    hcard = DiasporaFederation::Discovery::HCard.new({
      guid:             user.guid,
      diaspora_handle:  user.id,
      full_name:        user.username,
      url:              "#{config.testbed_url}/",
      photo_large_url:  "#{config.testbed_url}/profile.jpg",
      photo_medium_url: "#{config.testbed_url}/profile.jpg",
      photo_small_url:  "#{config.testbed_url}/profile.jpg",
      public_key:       user.public_key,
      searchable:       true,
      first_name:       user.username,
      last_name:        user.last_name,
      nickname:         user.username,
    })
    html_string = hcard.to_html
  end

  post "/receive/users/:guid" do |guid|
    user = test_data.find_by_guid_or_create(guid)
    slap_xml = URI.decode_www_form_component(params[:xml])
    slap = DiasporaFederation::Salmon::EncryptedSlap.from_xml(slap_xml, OpenSSL::PKey::RSA.new(user.private_key))
    author = test_data.find_by_id(slap.author_id)
    if author.nil?
      h_card = request_and_parse_hcard(request_and_parse_webfinger(slap.author_id, slap.author_id.match(/[^@]+@([^@]+)/)[0]))
      pubkey = h_card.public_key
    else
      pubkey = author.public_key
    end
    entity = slap.entity(OpenSSL::PKey::RSA.new(pubkey))
    pulled_entities.push(entity)
    ""
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
end
