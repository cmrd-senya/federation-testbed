require "singleton"
require 'yaml'

class Config
  include Singleton

  attr_reader :testbed_host
  attr_reader :server
  attr_reader :diaspora_user
  attr_reader :method

  def server_url
    @method + "://" + @server
  end

  def testbed_url
    @method + "://" + @testbed_host
  end

  def initialize
    config = YAML::load(File.open('features/support/config.yml'))
    @server = config["test_target"]["host"]
    @diaspora_user = config["test_target"]["user"] + "@" + @server
    @testbed_host = config["testbed_config"]["host"]
    @method = config['method']
  end
end
