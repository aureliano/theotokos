require 'test/unit'
require File.expand_path '../../../../lib/model/text_operator.rb', __FILE__

class TestTextOperator < Test::Unit::TestCase

  include Theotokos::Model
  
  def test_initialization
    _hash_initialization
    _block_initialization
  end
  
  private
  def _hash_initialization
    op = TextOperator.new({
      :contains => 'containing text', :not_contains => 'not containing text',
      :equals => 'text equals', :regex => 'regular expression'
    })
    
    assert_equal op.contains, 'containing text'
    assert_equal op.not_contains, 'not containing text'
    assert_equal op.equals, 'text equals'
    assert_equal op.regex, 'regular expression'
  end
  
  def _block_initialization
    op = TextOperator.new do |o|
      o.contains = 'containing text'
      o.not_contains = 'not containing text'
      o.equals = 'text equals'
      o.regex = 'regular expression'
    end
    
    assert_equal op.contains, 'containing text'
    assert_equal op.not_contains, 'not containing text'
    assert_equal op.equals, 'text equals'
    assert_equal op.regex, 'regular expression'
  end

end
