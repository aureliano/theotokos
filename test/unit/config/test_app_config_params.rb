require 'test/unit'
require 'yaml'
require File.expand_path '../../../../lib/config/app_config_params.rb', __FILE__

class TestAppConfigParams < Test::Unit::TestCase

  include Theotokos::Configuration
  
  def test_load_params
    ENV['app.cfg.path'] = 'test/app-cfg.yml'
    AppConfigParams.load_app_config_params
    
    assert_equal ENV['ws.config.path'], 'test/config/ws-config.yml'
    assert_equal ENV['logger.stdout.level'], 'info'
    assert_equal ENV['logger.stdout.layout.pattern'], '[%d] %-5l -- %c : %m\n'
    assert_equal ENV['logger.stdout.layout.date_pattern'], '%Y-%m-%d %H:%M:%S'
    assert_equal ENV['logger.rolling_file.level'], 'debug'
    assert_equal ENV['logger.rolling_file.file'], 'test/log/app-test.log'
    assert_equal ENV['logger.rolling_file.pattern'], '[%d] %-5l -- %c : %m\n'
    assert_equal ENV['logger.rolling_file.date_pattern'], '%Y-%m-%d %H:%M:%S'
  end
  
  def test_load_default_params
    ENV['app.cfg.path'] = nil
    AppConfigParams.load_app_config_params
    
    assert_equal ENV['ws.config.path'], 'resources/config/ws-config.yml'
    assert_equal ENV['ws.test.models.path'], 'resources/ws-test-models'
    assert_equal ENV['ws.test.output.files.path'], 'resources/outputs'
    assert_equal ENV['ws.test.reports.locales.path'], 'resources/locales'
    assert_equal ENV['ws.test.reports.locale'], 'en'
    assert_equal ENV['ws.test.reports.path'], 'tmp/reports'
  end
  
end
