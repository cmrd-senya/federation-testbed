require "singleton"
require "uuid"
require "./features/support/config"

class GeneratedData
  include Singleton
  attr_reader :test_user_name
  attr_reader :test_user_id
  attr_reader :private_key
  attr_reader :public_key
  attr_reader :guid

  def initialize
    @test_user_name ="user-#{Time.now.to_i}" 
    @test_user_id = @test_user_name + "@" + Config.instance.testbed_host
    key_size = 1024
    pkey = OpenSSL::PKey::RSA::generate(key_size)
    @private_key = pkey.to_s
    @public_key = pkey.public_key.to_s
    @guid = UUID.generate :compact
  end
end
