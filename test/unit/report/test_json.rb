require 'test/unit'
require 'json'

require File.expand_path '../../../../lib/report/reporter.rb', __FILE__
require File.expand_path '../../../../lib/report/json.rb', __FILE__
require File.expand_path '../../../../lib/model/test_result.rb', __FILE__

class TestJson < Test::Unit::TestCase

  include Report
  include Model
  
  def test_print_success_test_result
    test = TestResult.new do |t|
      t.name = '1'
      t.test_expectation = { 'file' => 'test/ws-test-models/do_something.yml', 'text' => { :equals => 'test 123'} }
      t.status = TestStatus.new :test_file_status => true, :test_text_status => true
      t.test_actual = 'test/ws-test-models/do_something.yml'
    end
    
    expected = ""
    
    output = File.read Reporter.create_reporter(:json).print(test)
    assert_equal expected, output
  end

end
