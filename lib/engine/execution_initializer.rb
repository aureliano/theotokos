module Engine

  class ExecutionInitializer
  
    def initialize
      @suites = Hash.new
      yield self if block_given?
    end
    
    def init_executors
      raise Exception, 'Execution command params must not be empty.' unless @command      
    end
  
    def load_resources
      models_path = "#{ENV['ws.test.models.path']}/**/*.yml"
      Dir.glob(models_path).map {|file| file }
    end
    
    attr_accessor :command
    attr_reader :suites
  
  end

end
