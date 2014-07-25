require 'test/unit'
require 'json'

require File.expand_path '../../../../lib/report/reporter.rb', __FILE__
require File.expand_path '../../../../lib/report/json.rb', __FILE__
require File.expand_path '../../../../lib/model/test_result.rb', __FILE__

class TestJson < Test::Unit::TestCase

  include Theotokos::Report
  include Theotokos::Model
  
  def test_print_success_test_result
    app = TestAppResult.new do |a|
      a.suites = []
      a.suites << TestSuiteResult.new do |s|
        s.model = TestSuite.new {|t| t.source = '/path/to/test/model1' }
        s.test_results = [
          TestResult.new {|t| t.status = TestStatus.new :test_file_status => true },
          TestResult.new {|t| t.status = TestStatus.new :test_text_status => { :equals => true } },
          TestResult.new {|t| t.name = 1; t.status = TestStatus.new :test_text_status => { :equals => false } }
        ]
      end
      
      a.suites << TestSuiteResult.new do |s|
        s.model = TestSuite.new {|t| t.source = '/path/to/test/model2' }
        s.test_results = [
          TestResult.new {|t| t.status = TestStatus.new :test_file_status => true },
          TestResult.new {|t| t.status = TestStatus.new :test_text_status => { :equals => true } }
        ]
      end
      a.calculate_totals
    end
    
    output = File.read Reporter.create_reporter(:json).print(app)
    hash = JSON.parse output
    
    assert_equal 1, hash['total_failures']
    assert_equal 1, hash['total_success']
  end

end
