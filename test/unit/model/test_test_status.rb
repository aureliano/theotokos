require 'test/unit'
require File.expand_path '../../../../lib/model/test_status.rb', __FILE__

class TestTestStatus < Test::Unit::TestCase

  include Model
  
  def test_initialization
    _hash_initialization
    _block_initialization
  end
  
  def test_success
    status = TestStatus.new :test_file_status => true, :test_text_status => { :equals => true }
    assert status.success?
    
    status.error = false
    assert status.success?
    assert !status.error?
    
    status.error = true
    assert !status.success?
    assert status.error?
    
    status.test_file_status = false
    assert status.success? == false
    
    status.test_text_status = false
    assert status.success? == false
    
    status.test_file_status = true
    assert status.success? == false
  end
  
  def test_error
    status = TestStatus.new :test_file_status => false, :test_text_status => { :equals => false }
    assert status.error?
    
    status.test_file_status = true
    assert status.error?
    
    status.test_text_status = { :equals => true }
    assert status.error? == false
  end
  
  private
  def _hash_initialization
    status = TestStatus.new({
      :test_file_status => true, :test_text_status => false
    })
    
    assert status.test_file_status == true
    assert status.test_text_status == false
  end
  
  def _block_initialization
    status = TestStatus.new do |s|
      s.test_file_status = true
      s.test_text_status = false
    end
    
    assert status.test_file_status == true
    assert status.test_text_status == false
  end

end
