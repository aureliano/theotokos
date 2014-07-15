require 'test/unit'
require File.expand_path '../../../../lib/model/execution.rb', __FILE__

class TestExecution < Test::Unit::TestCase

  include Theotokos::Model
  
  def test_initialization
    exec = Execution.new
    assert_equal exec.report_formats, [:console]
    assert_nil exec.test_files
    assert_nil exec.test_index
    assert_nil exec.tags
    
    exec.test_files = ['/path/to/file.yml']
    assert_equal exec.test_files, ['/path/to/file.yml']
    
    exec.test_index = 1
    assert_equal exec.test_index, 1
    
    exec.tags = ['dev', 'test']
    assert_equal exec.tags, ['dev', 'test']
  end
  
end
