require 'test/unit'

require File.expand_path '../../../../lib/report/reporter.rb', __FILE__
require File.expand_path '../../../../lib/report/console.rb', __FILE__
require File.expand_path '../../../../lib/report/json.rb', __FILE__
require File.expand_path '../../../../lib/report/html.rb', __FILE__

class TestReporter < Test::Unit::TestCase

  include Report
  
  def test_create_reporter
    assert_instance_of Console, Reporter.create_reporter
    assert_instance_of Console, Reporter.create_reporter(:console)
    assert_instance_of Console, Reporter.create_reporter('console')
    
    assert_instance_of Json, Reporter.create_reporter(:json)
    assert_instance_of Json, Reporter.create_reporter('json')
    
    assert_instance_of Html, Reporter.create_reporter(:html)
    assert_instance_of Html, Reporter.create_reporter('html')
  end
  
end

