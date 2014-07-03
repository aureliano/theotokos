require 'test/unit'
require File.expand_path '../../../../lib/model/test_suite_result.rb', __FILE__
require File.expand_path '../../../../lib/model/test_result.rb', __FILE__
require File.expand_path '../../../../lib/model/test_app_result.rb', __FILE__

class TestTestAppResult < Test::Unit::TestCase

  include Model
  
  def test_calculate_totals
    
  end
  
  def test_result
    res = TestAppResult.new
    res.suites = _prepare_data_to_success
    
    res.calculate_totals
    assert res.success?
    
    res.suites = _prepare_data
    res.calculate_totals
    assert res.error?
  end
  
  private
  def _prepare_data
    suites = []
    suites << TestSuiteResult.new {|s| s.test_results = _prepare_data_to_suite_success }
    suites << TestSuiteResult.new {|s| s.test_results = _prepare_data_to_suite_success }
    suites << TestSuiteResult.new {|s| s.test_results = _prepare_data_to_suite_success }
    suites << TestSuiteResult.new {|s| s.test_results = _prepare_data_to_suite_error }
    
    suites
  end
  
  def _prepare_data_to_success
    suites = []
    suites << TestSuiteResult.new {|s| s.test_results = _prepare_data_to_suite_success }
    suites << TestSuiteResult.new {|s| s.test_results = _prepare_data_to_suite_success }
    suites << TestSuiteResult.new {|s| s.test_results = _prepare_data_to_suite_success }
    
    suites
  end
  
  def _prepare_data_to_suite_success
    10.times.map do
      TestResult.new do |t|
        t.status = TestStatus.new :test_file_status => true
      end
    end
  end
  
  def _prepare_data_to_suite_error
    5.times.map do
      TestResult.new do |t|
        t.status = TestStatus.new :test_file_status => false
      end
    end
  end
  
end
