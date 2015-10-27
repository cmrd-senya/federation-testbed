require "singleton"
require "uuid"
require "federation-testbed/config"

module FederationTestbed
end

class FederationTestbed::User
  attr_accessor :username
  attr_accessor :last_name
  attr_accessor :id
  attr_accessor :private_key
  attr_accessor :public_key
  attr_accessor :guid

  def initialize
    @username ="user-#{Time.now.to_f}"
    @last_name = "at the testbed"
    @id = @username + "@" + FederationTestbed.config.testbed_host
    key_size = 1024
    pkey = OpenSSL::PKey::RSA::generate(key_size)
    @private_key = pkey.to_s
    @public_key = pkey.public_key.to_s
    @guid = UUID.generate :compact
  end
end

class FederationTestbed::GeneratedData
  include Singleton
  def test_user_name
    @user_list.last.username
  end

  def test_user_id
    @user_list.last.id
  end

  def private_key
    @user_list.last.private_key
  end

  def public_key
    @user_list.last.public_key
  end

  def guid
    @user_list.last.guid
  end

  def initialize
    @user_list = []
    roll
  end

  def roll
     @user_list.push(FederationTestbed::User.new)
  end

  def find_by_id_or_create(id)
    @user_list.each do |u|
      if u.id == id
        return u
      end
    end
    roll
    @user_list.last.id = id
    @user_list.last
  end
end
