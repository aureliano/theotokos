require 'test/unit'
require File.expand_path '../../../../lib/model/test.rb', __FILE__

class TestTest < Test::Unit::TestCase

  include Theotokos::Model
  
  def test_read_methods_presence
    test = Test.new
    assert test.respond_to? 'name'
    assert test.respond_to? 'description'
    assert test.respond_to? 'input'
    assert test.respond_to? 'output'
    assert test.respond_to? 'ws_security'
    assert test.respond_to? 'tags'
    assert test.respond_to? 'error_expected'
    assert test.respond_to? 'skip'
  end
  
  def test_write_methods_presence
    test = Test.new
    assert test.respond_to? 'name='
    assert test.respond_to? 'description='
    assert test.respond_to? 'input='
    assert test.respond_to? 'output='
    assert test.respond_to? 'ws_security='
    assert test.respond_to? 'tags='
    assert test.respond_to? 'error_expected='
    assert test.respond_to? 'skip='
  end
  
  def test_has_tag
    test = Test.new {|t| t.tags = ["dev", "ss1"] }
    
    assert !test.has_tag?('dev1')
    assert !test.has_tag?('tag')
    
    assert test.has_tag?('dev')
    assert test.has_tag?('ss1')
  end
  
end  
