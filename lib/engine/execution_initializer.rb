module Engine

  class ExecutionInitializer
  
    def initialize
      @suites = Hash.new      
      yield self if block_given?
    end
    
    def init_executors
      raise Exception, 'Execution command params must not be empty.' unless @command
      ws_config = WsConfig.load_ws_config
      
      @command.test_files.each do |file|
        model = nil
        begin
          model = Parser.yaml_to_test_suite file
        rescue Exception => ex
          @suites[file] = ExecutionInitializer.error_test_suite_result ex
        end
        
        model.source = file
        @suites[file] = SoapExecutor.new do |exe|
          exe.test_suite = model
          exe.test_index = @command.test_index
          exe.ws_config = ws_config
        end.execute
        
        puts
      end
    end
  
    def self.load_test_models
      models_path = "#{ENV['ws.test.models.path']}/**/*.yml"
      Dir.glob(models_path).map {|file| file }
    end
    
    def self.error_test_suite_result(ex)
      TestSuiteResult.new do |r|
        r.model = TestSuite.new do |s|
          s.source = file
          s.wsdl = '???'
          s.service = '???'
        end
        
        r.test_results = [
          TestResult.new do |test|
            test.name = '1'
            test.status = TestStatus.new :test_file_status => false, :test_text_status => false
            test.error = { :message => ex.to_s, :backtrace => ex.backtrace }
          end
        ]
      end
    end
    
    attr_accessor :command
    attr_reader :suites
  
  end

end
