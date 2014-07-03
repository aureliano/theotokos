require 'test/unit'
require 'yaml'
require File.expand_path '../../../../../lib/config/app_config_params.rb', __FILE__

class TestAppConfigParams < Test::Unit::TestCase

  include Configuration
  
  def test_load_params
    ENV['app.cfg.path'] = 'test/app-cfg.yml'
    AppConfigParams.load_app_config_params
    
    assert_equal ENV['ws.config.path'], 'test/config/ws-config.yml'
  end
  
  def test_load_default_params
    ENV['app.cfg.path'] = nil
    AppConfigParams.load_app_config_params
    
    assert_equal ENV['ws.config.path'], 'resources/config/ws-config.yml'
  end
  
end
