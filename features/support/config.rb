require "singleton"
require 'yaml'

class Config
  include Singleton

  attr_reader :testbed_host
  attr_reader :diaspora_user

  def server_url
    @diaspora_method + "://" + @diaspora_host
  end

  def testbed_url
    @testbed_method + "://" + @testbed_host
  end

  def read_config_file
    config = YAML::load(File.open('features/support/config.yml'))
    configure(config)
  end

  def configure(config)
    @diaspora_method = config["test_target"]["method"]
    @diaspora_host = config["test_target"]["host"]
    @diaspora_user = config["test_target"]["user"] + "@" + @diaspora_host
    @testbed_method = config["testbed_config"]['method']
    @testbed_host = config["testbed_config"]["host"]
  end
end
