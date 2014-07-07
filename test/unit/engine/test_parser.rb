require 'test/unit'
require File.expand_path '../../../../lib/model/test_suite.rb', __FILE__
require File.expand_path '../../../../lib/model/test.rb', __FILE__
require File.expand_path '../../../../lib/engine/parser.rb', __FILE__

class TestParser < Test::Unit::TestCase

  include Model
  include Engine
  
  def test_yaml_to_hash
    assert_raise(Exception, 'File path/to/unexisting/file does not exist.') { Parser.yaml_to_hash 'path/to/unexisting/file' }

    hash = Parser.yaml_to_hash 'test/app-cfg.yml'
    assert_instance_of Hash, hash
  end
  
  def test_hash_to_test_suite
    hash = Parser.yaml_to_hash 'test/ws-test-models/do_something.yml'
    suite = Parser.hash_to_test_suite hash
    
    assert_equal suite.wsdl, 'http://path/to/wsdl'
    assert_equal suite.service, 'do_something'
    assert_equal suite.tags.sort, ['dev']
  end
  
  def test_yaml_to_test_suite
    suite = Parser.yaml_to_test_suite 'test/ws-test-models/do_something.yml'
    
    assert_equal suite.wsdl, 'http://path/to/wsdl'
    assert_equal suite.service, 'do_something'
    assert_equal suite.tags.sort, ['dev']
  end
  
end
