require 'test/unit'
require File.expand_path '../../../../lib/model/test.rb', __FILE__

class TestTest < Test::Unit::TestCase

  include Model
  
  def test_read_methods_presence
    test = Test.new
    assert test.respond_to? 'input'
    assert test.respond_to? 'output'
    assert test.respond_to? 'ws_security'
  end
  
  def test_write_methods_presence
    test = Test.new
    assert test.respond_to? 'input='
    assert test.respond_to? 'output='
    assert test.respond_to? 'ws_security='
  end
  
end  
