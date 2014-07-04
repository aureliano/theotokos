require 'test/unit'
require 'yaml'
require File.expand_path '../../../../lib/engine/parser.rb', __FILE__

class TestParser < Test::Unit::TestCase

  include Engine
  
  def test_parse_yaml
    assert_raise(Exception, 'File path/to/unexisting/file does not exist.') { Parser.parse_yaml 'path/to/unexisting/file' }

    hash = Parser.parse_yaml 'test/app-cfg.yml'
    assert_instance_of Hash, hash
  end
  
end
