require 'test/unit'
require File.expand_path '../../../../lib/model/test_suite_result.rb', __FILE__
require File.expand_path '../../../../lib/model/test_result.rb', __FILE__

class TestTestSuiteResult < Test::Unit::TestCase

  include Model
  
  def test_calculate_totals
    res = 10.times.map do
      TestResult.new do |t|
        t.status = TestStatus.new :test_file_status => true
      end
    end
    
    14.times.map do
      res << TestResult.new do |t|
        t.status = TestStatus.new :test_text_status => true
      end
    end
    
    5.times.map do
      res << TestResult.new do |t|
        t.status = TestStatus.new :test_file_status => false
      end
    end
    
    2.times.map do
      res << TestResult.new do |t|
        t.status = TestStatus.new :test_text_status => false
      end
    end
  
    suite = TestSuiteResult.new
    suite.test_results = res
    
    suite.calculate_totals
    
    assert_equal suite.total_failures, 7
    assert_equal suite.total_success, 24
  end
  
end
