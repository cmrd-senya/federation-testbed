require 'sinatra'
require "bundler/setup"
require 'diaspora_federation'
require "nokogiri"
require 'open-uri'
require "erb"
require "rest-client"

set :bind, "0.0.0.0"

before do
	@new_post
	@posts_array = []
	set_up_user
end

def set_up_user
	@user = "deleted_soon"
	@guid = '20bae424196dac5a'
end

def get_stream
  @doc = Nokogiri::XML(open('https://joindiaspora.com/public/carolinagc.atom'))
  @post_titles = @doc.xpath('//xmlns:title')

  @post_titles_str = ""
  for i in 1..(@post_titles.length - 1)
    @p = @post_titles[i].to_html
    @post_titles_str << @p.gsub!("title", "div class=post_titles ") << "<a id=" << i.to_s << " onclick='jump_to(id)'>read more </a>"
  end

  @post_bodies = @doc.xpath('//xmlns:content')
  @post_bodies_str = ""
  for i in 1..(@post_bodies.length - 1)
    @p = @post_bodies[i].to_html
    @post_bodies_str << @p.gsub!("content", "div class=post_titles " << "id=" << (100*i).to_s)
  end
end

def generate_xml_public(post_content)
	#generates from the post content the xml which is needed to send it to other pods
  e = DiasporaFederation::Entities::StatusMessage.new({
      raw_message: '#{post_content}', guid: SecureRandom.hex(16),
      diaspora_handle: "#{@user}@tinyd.heroku.com", created_at: DateTime.now, public: true })
  @xml = DiasporaFederation::Salmon::Slap.generate_xml("#{@user}@tinyd.heroku.com", @private_key, e)
  RestClient.post "https://wk3.org/receive/public", {:xml => @xml}
end

def read_posts_file()
	posts_file = File.open('posts.txt', 'a+') 
	posts_file.each_line {|line| @posts_array.push(line)}
	posts_file.close
end

def save_posts_to_file(post_content)
	posts_file = File.open('posts.txt', 'a+')
	posts_file << post_content << "\n"
	posts_file.close
end


#routes

get '/.well-known/host-meta' do
  hostmeta = DiasporaFederation::Discovery::HostMeta.from_base_url(Config.instance.testbed_url)
  hostmeta.to_xml
end

get '/' do
  get_stream 
  read_posts_file()   
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
  get_stream
 	@new_post = "#{params[:post_content]}"
 	generate_xml_public(@new_post)
 	save_posts_to_file(@new_post)
 	read_posts_file()
  erb :index
end

get '/public/user.atom'  do
  @doc = Nokogiri::XML(open('https://joindiaspora.com/public/carolinagc.atom'))
  @post_title = @doc.xpath('//xmlns:title')

  builder :feed
end

get '/read_post' do

end

get "/people/:guid/stream" do |guid|
  [].to_json
end
