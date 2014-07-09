require 'test/unit'
require 'yaml'
require File.expand_path '../../../../lib/model/ws_config.rb', __FILE__
require File.expand_path '../../../../lib/config/app_config_params.rb', __FILE__

class TestWsConfig < Test::Unit::TestCase

  include Model
  include Configuration
  
  def test_load_ws_config
    _prepare_test
    
    conf = WsConfig.load_ws_config
    assert_equal conf.namespaces, { 'xmlns:soapenv' => 'http://schemas.xmlsoap.org/soap/envelope/', 'xmlns:wsdl' => 'http://interfaceSiconv.cs.siconv.mp.gov.br/' }
    assert_equal conf.env_namespace, 'soapenv'
    assert_equal conf.ssl_verify_mode, :none
    assert_equal conf.ssl_version, :SSLv3
    assert_equal conf.ssl_cert_file, '/path/to/cert.file'
    assert_equal conf.ssl_cert_key_file, '/path/to/cert/key/file'
    assert_equal conf.ssl_ca_cert_file, '/path/to/ca/cert/file'
    assert_equal conf.ssl_cert_key_password, 'pass'
  end
  
  private
  def _prepare_test
    ENV['app.cfg.path'] = 'test/app-cfg.yml'
    AppConfigParams.load_app_config_params
  end
  
end
