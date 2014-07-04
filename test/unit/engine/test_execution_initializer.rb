require 'test/unit'
require File.expand_path '../../../../lib/engine/execution_initializer.rb', __FILE__
require File.expand_path '../../../../lib/model/execution.rb', __FILE__

class TestExecutionInitializer < Test::Unit::TestCase

  include Engine
  include Model
  
  def test_init_executors
    assert_raise(Exception, 'Execution command params must not be empty.') { ExecutionInitializer.new.init_executors }
  end
  
  def test_load_resources
    init = ExecutionInitializer.new
    
    assert_equal init.load_resources.sort, ['test/ws-test-models/do_something.yml', 'test/ws-test-models/project1/look_for_stuff.yml'].sort
  end
  
end
