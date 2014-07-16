require 'test/unit'
require File.expand_path '../../../../lib/model/test_suite.rb', __FILE__

class TestTestSuite < Test::Unit::TestCase

  include Theotokos::Model
  
  def test_initialization
    _hash_initialization
    _block_initialization
  end
  
  def test_validation
    props = {
      :source => '/path/to/test/case/model/file', :wsdl => 'http://path/to/wsdl?wsdl',
      :service => 'test_service', :tags => ['dev', 'test', 'production']
    }
    
    assert_nothing_raised { TestSuite.new(props).validate_model! }

    props[:source] = nil
    assert_raise(Exception, 'WS test model must be provided.') { TestSuite.new(props).validate_model! }
    
    props[:source] = '/path/to/test/case/model/file'
    props[:wsdl] = nil
    assert_raise(Exception, "WSDL's URL must be provided.") { TestSuite.new(props).validate_model! }
    
    props[:wsdl] = 'http://path/to/wsdl?wsdl'
    props[:service] = nil
    assert_raise(Exception, 'Service name (service to be tested) must be provided.') { TestSuite.new(props).validate_model! }
  end
  
  private
  def _hash_initialization
    props = {
      :source => '/path/to/test/case/model/file', :wsdl => 'http://path/to/wsdl?wsdl',
      :service => 'test_service', :description => 'some description', :tags => ['dev', 'test', 'production']
    }
    suite = TestSuite.new(props)
    
    assert_equal suite.source, '/path/to/test/case/model/file'
    assert_equal suite.wsdl, 'http://path/to/wsdl?wsdl'
    assert_equal suite.service, 'test_service'
    assert_equal suite.description, 'some description'
    assert_equal suite.tags, ['dev', 'test', 'production']
    assert_equal suite.tests, []
    
    props[:tags] = 'dev, test'
    assert_equal TestSuite.new(props).tags, ['dev', 'test']
    
    props[:tags] = nil
    assert_equal TestSuite.new(props).tags, []
  end
  
  def _block_initialization
    suite = TestSuite.new do |suite|
      suite.source = '/path/to/test/case/model/file'
      suite.wsdl = 'http://path/to/wsdl?wsdl'
      suite.service = 'test_service'
      suite.description = 'some description'
      suite.tags = ['dev', 'test', 'production']
    end
        
    assert_equal suite.source, '/path/to/test/case/model/file'
    assert_equal suite.wsdl, 'http://path/to/wsdl?wsdl'
    assert_equal suite.service, 'test_service'
    assert_equal suite.description, 'some description'
    assert_equal suite.tags, ['dev', 'test', 'production']
    assert_equal suite.tests, []
  end

end
