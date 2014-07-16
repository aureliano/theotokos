require 'test/unit'

require File.expand_path '../../../../lib/report/reporter.rb', __FILE__
require File.expand_path '../../../../lib/report/console.rb', __FILE__
require File.expand_path '../../../../lib/model/test_result.rb', __FILE__

class TestConsole < Test::Unit::TestCase

  include Report
  include Theotokos::Model
  
  def test_print_success_test_result
    test = TestResult.new do |t|
      t.name = '1'
      t.description = 'some description'
      t.test_expectation = { 'file' => 'test/ws-test-models/do_something.yml', 'text' => { :equals => 'test 123'} }
      t.status = TestStatus.new :test_file_status => true, :test_text_status => { :equals => true }
      t.test_actual = 'test/ws-test-models/do_something.yml'
    end
    
    expected = "Test case: #1\nTest description: some description\nTest expectations.\n => File 'test/ws-test-models/do_something.yml'\n"
    expected << File.read('test/ws-test-models/do_something.yml')
    expected << "\n => Status: Passed\n\n"
    expected << " => Text\n\nequals: test 123\nStatus: Passed\n"
    expected << "\n- Found output.\n"
    expected << File.read('test/ws-test-models/do_something.yml')
    expected << "\n\n- Test case status: Success"
    expected << "\n\n------\n\n"
    
    output = Reporter.create_reporter(:console).print test
    assert_equal expected, output
  end
  
  def test_print_fail_test_result
    test = TestResult.new do |t|
      t.name = '1'
      t.description = 'some description'
      t.test_expectation = { 'file' => 'test/ws-test-models/do_something.yml', 'text' => { :equals => 'test 123'} }
      t.status = TestStatus.new :test_file_status => false, :test_text_status => { :equals => true }
      t.test_actual = 'test/ws-test-models/project1/look_for_stuff.yml'
    end
    
    expected = "Test case: #1\nTest description: some description\nTest expectations.\n => File 'test/ws-test-models/do_something.yml'\n"
    expected << File.read('test/ws-test-models/do_something.yml')
    expected << "\n => Status: Failed\n\n"
    expected << " => Text\n\nequals: test 123\nStatus: Passed\n"
    expected << "\n- Found output.\n"
    expected << File.read('test/ws-test-models/project1/look_for_stuff.yml')
    expected << "\n\n- Test case status: Fail"
    expected << "\n\n------\n\n"
    
    output = Reporter.create_reporter(:console).print test
    assert_equal expected, output
  end
  
  def test_print_test_suite_result
    suite = TestSuiteResult.new do |s|
      s.test_results = [
        TestResult.new {|t| t.status = TestStatus.new :test_file_status => true },
        TestResult.new {|t| t.status = TestStatus.new :test_text_status => { :equals => true } },
        TestResult.new {|t| t.status = TestStatus.new :test_text_status => { :equals => false } }
      ]
      s.calculate_totals
    end
    
    expected = "-" * 100
    expected << "\nTotal test success: #{suite.total_success}"
    expected << "\nTotal test failures: #{suite.total_failures}"
    
    output = Reporter.create_reporter(:console).print suite
    assert_equal expected, output
  end
  
  def test_print_test_app_result
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
    
    expected = "*" * 100
    expected << "\nTotal test suites success: #{app.total_success}"
    expected << "\nTotal test suites failures: #{app.total_failures}"
    expected << "\n\n"
    expected << "*" * 100
    expected << "\n- Broken tests\nTest suite: /path/to/test/model1\nTest cases: #1"
    
    output = Reporter.create_reporter(:console).print app
    assert_equal expected, output
  end
  
end
