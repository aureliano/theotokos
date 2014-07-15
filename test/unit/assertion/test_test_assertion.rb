require 'test/unit'
require 'equivalent-xml'
require File.expand_path '../../../../lib/assertion/test_assertion.rb', __FILE__

class TestAssertion < Test::Unit::TestCase

  include Theotokos::Assertion
  
  def test_compare_file
    assert_raise(Exception, "File /path/to/file1 does not exist") { TestAssertion.compare_file '/path/to/file1', '/path/to/file2' }
    assert_raise(Exception, "File /path/to/file2 does not exist") { TestAssertion.compare_file 'test/app-cfg.yml', '/path/to/file' }
    
    assert TestAssertion.compare_file 'test/app-cfg.yml', 'test/app-cfg.yml'
    assert !TestAssertion.compare_file('test/app-cfg.yml', 'test/ws-test-models/do_something.yml')
  end
  
  def test_compare_text
    t1 = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><params><param>test</param><param>equals</param></params></soap:Body></soap:Envelope>'
    t2 = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><params><param>equals</param><param>test</param></params></soap:Body></soap:Envelope>'
    assert TestAssertion.compare_text t1, t2, :equals
    assert !TestAssertion.compare_text('equal', 'equals', :equals)
    
    assert TestAssertion.compare_text 'xt equal', 'Is the text equal?', :contains
    assert !TestAssertion.compare_text('test equal', 'Is the text equal?', :contains)
    
    assert TestAssertion.compare_text 'equal', 'There is no such word', :not_contains
    assert !TestAssertion.compare_text('text equal', 'Is the text equal?', :not_contains)
    
    assert TestAssertion.compare_text /^<soap:/, t1, :regex
    assert !TestAssertion.compare_text(/exist/, t1, :regex)
  end
  
  def test_assert_equals
    assert TestAssertion.assert_equals 'equal', 'equal'
    assert !TestAssertion.assert_equals('equal', 'equals')
    
    t1 = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><params><param>test</param><param>equals</param></params></soap:Body></soap:Envelope>'
    t2 = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><params><param>equals</param><param>test</param></params></soap:Body></soap:Envelope>'
    assert TestAssertion.assert_equals t1, t2

    t2.sub! 'equals', 'equal'
    assert !TestAssertion.assert_equals(t1, t2)
  end
  
  def test_assert_contains
    assert TestAssertion.assert_contains('equal', 'equal')
    assert TestAssertion.assert_contains('xt equal', 'Is the text equal?')
    assert !TestAssertion.assert_contains('test equal', 'Is the text equal?')
    
    xml = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><params><param>test</param><param>equals</param></params></soap:Body></soap:Envelope>'
    assert TestAssertion.assert_contains('equals', xml)
    assert !TestAssertion.assert_contains('teste', xml)
  end
  
  def test_assert_not_contains
    assert TestAssertion.assert_not_contains('equal', 'There is no such word')
    assert TestAssertion.assert_not_contains('what', 'Is the text equal?')
    assert !TestAssertion.assert_not_contains('text equal', 'Is the text equal?')
    
    xml = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><params><param>test</param><param>equals</param></params></soap:Body></soap:Envelope>'
    assert !TestAssertion.assert_not_contains('equals', xml)
    assert TestAssertion.assert_not_contains('teste', xml)
  end
  
  def test_assert_match
    xml = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><params><param>test</param><param>equals</param></params></soap:Body></soap:Envelope>'
    assert TestAssertion.assert_match(/^<soap:/, xml)
    assert TestAssertion.assert_match('^<soap:', xml)
    assert !TestAssertion.assert_match(/exist/, xml)
  end
  
end
