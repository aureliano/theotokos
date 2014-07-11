module Engine

  class ExecutionInitializer
  
    def initialize
      yield self if block_given?
    end
    
    def init_executors
      raise Exception, 'Execution command params must not be empty.' unless @command
      ws_config = WsConfig.load_ws_config
      suites = []
      console_report = Reporter.create_reporter(:console) if @command.report_formats.include? :console
      
      @command.test_files.each do |file|
        model = nil
        begin
          model = Parser.yaml_to_test_suite file
        rescue Exception => ex
          @suites[file] = ExecutionInitializer.error_test_suite_result ex
        end

        model.source = file

        suite = SoapExecutor.new do |exe|
          exe.test_suite = model
          exe.test_index = @command.test_index
          exe.ws_config = ws_config
          exe.console_report = console_report
        end.execute
        
        suite.calculate_totals
        console_report.print suite unless console_report.nil?
        suites << suite
        puts
      end
      
      @test_app_result = TestAppResult.new do |t|
        t.suites = suites
        t.calculate_totals
      end
      
      console_report.print @test_app_result unless console_report.nil?
    end
  
    def self.load_test_models(path)
      ((path.nil?) ? ExecutionInitializer.load_all_test_models : ExecutionInitializer.load_test_models_by_path(path))
    end
    
    def self.load_test_models_by_path(model_path)
      path = model_path.dup

      unless path.end_with? '.yml'
        path << '/' unless path.end_with? '/'
        path << '**/*.yml'
      end
      
      Dir.glob(path).map {|file| file }
    end
    
    def self.load_all_test_models
      ExecutionInitializer.load_test_models_by_path ENV['ws.test.models.path']
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
    attr_reader :test_app_result
  
  end

end
