require 'test/unit'
require File.expand_path '../../../../lib/model/test_suite_result.rb', __FILE__
require File.expand_path '../../../../lib/model/test_result.rb', __FILE__
require File.expand_path '../../../../lib/model/test_app_result.rb', __FILE__

class TestTestAppResult < Test::Unit::TestCase

  include Theotokos::Model
  
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
  
  def test_success_failures_stats
    res = TestAppResult.new
    res.suites = _prepare_data
    
    res.calculate_totals
    stats = res.success_failures_stats
    
    assert_equal 3, stats[:success][:total]
    assert_equal 75, stats[:success][:stat]
    
    assert_equal 1, stats[:failures][:total]
    assert_equal 25, stats[:failures][:stat]
  end
  
  def test_tags_stats
    res = TestAppResult.new
    res.suites = _prepare_data
    
    stats = res.tags_stats
    
    assert_equal 5, stats[:dev][:total]
    assert_equal 14.29, stats[:dev][:stat]
    
    assert_equal 5, stats[:test][:total]
    assert_equal 14.29, stats[:test][:stat]
    
    assert_equal 30, stats[:prod][:total]
    assert_equal 85.71, stats[:prod][:stat]
  end
  
  private
  def _prepare_data
    suites = []
    suites << TestSuiteResult.new do |s|
      s.model = TestSuite.new {|m| m.tags = [] }
      s.test_results = _prepare_data_to_suite_success
    end
    suites << TestSuiteResult.new do |s|
      s.model = TestSuite.new {|m| m.tags = [] }
      s.test_results = _prepare_data_to_suite_success
    end
    suites << TestSuiteResult.new do |s|
      s.model = TestSuite.new {|m| m.tags = [] }
      s.test_results = _prepare_data_to_suite_success
    end
    suites << TestSuiteResult.new do |s|
      s.model = TestSuite.new {|m| m.tags = [] }
      s.test_results = _prepare_data_to_suite_error
    end
    
    suites
  end
  
  def _prepare_data_to_success
    suites = []
    suites << TestSuiteResult.new do |s|
      s.model = TestSuite.new {|m| m.tags = [] }
      s.test_results = _prepare_data_to_suite_success
    end
    suites << TestSuiteResult.new do |s|
      s.model = TestSuite.new {|m| m.tags = [] }
      s.test_results = _prepare_data_to_suite_success
    end
    suites << TestSuiteResult.new do |s|
      s.model = TestSuite.new {|m| m.tags = [] }
      s.test_results = _prepare_data_to_suite_success
    end
    
    suites
  end
  
  def _prepare_data_to_suite_success
    10.times.map do
      TestResult.new do |t|
        t.tags = %W(prod)
        t.status = TestStatus.new :test_file_status => true
      end
    end
  end
  
  def _prepare_data_to_suite_error
    5.times.map do
      TestResult.new do |t|
        t.tags = %W(dev test)
        t.status = TestStatus.new :test_file_status => false
      end
    end
  end
  
end
