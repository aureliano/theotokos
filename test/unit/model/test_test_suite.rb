require 'test/unit'
require File.expand_path '../../../../bin/model/test_suite.rb', __FILE__

class TestTestSuite < Test::Unit::TestCase

  include Model
  
  def test_initialization
    props = {
      :source => '/path/to/test/case/model/file', :wsdl => 'http://path/to/wsdl?wsdl',
      :service => 'test_service', :tags => ['dev', 'test', 'production']
    }
    suite = TestSuite.new(props)
    
    assert_equal suite.source, '/path/to/test/case/model/file'
    assert_equal suite.wsdl, 'http://path/to/wsdl?wsdl'
    assert_equal suite.service, 'test_service'
    assert_equal suite.tags, ['dev', 'test', 'production']
    assert_nil suite.tests
    
    props[:tags] = 'dev, test'
    assert_equal TestSuite.new(props).tags, ['dev', 'test']
    
    props[:tags] = nil
    assert_equal TestSuite.new(props).tags, []
  end

end
