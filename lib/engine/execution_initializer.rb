module Theotokos
  module Engine

    class ExecutionInitializer
    
      def initialize
        yield self if block_given?
      end
      
      def init_executors
        raise Exception, 'Execution command params must not be empty.' unless @command
        puts "\n >>> Tags: #{@command.tags.join(', ')}\n\n" unless (@command.tags.nil? || @command.tags.empty?)
        suites = []
        console_report = Reporter.create_reporter(:console) if @command.report_formats.include? :console
        
        ExecutionInitializer._before_app
        Helper.load_support_files
        
        @command.test_files.each do |file|
          model = nil
          begin
            model = Parser.yaml_to_test_suite file
          rescue Exception => ex
            suites << ExecutionInitializer.error_test_suite_result(ex, file)
            puts "WARN: Error parsing model '#{file}': #{ex}"
            next
          end

          model.source = file

          suite = SoapExecutor.new do |exe|
            exe.test_suite = model
            exe.test_index = @command.test_index
            exe.ws_config = @ws_config
            exe.tags_input = @command.tags
            exe.console_report = console_report
          end.execute
          
          next if suite.nil?
          
          suite.calculate_totals
          console_report.print suite unless console_report.nil?
          suites << suite
          puts
        end
        
        @test_app_result = TestAppResult.new do |t|
          t.suites = suites
          t.calculate_totals
        end
        
        ExecutionInitializer._after_app @test_app_result
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
      
      def self.error_test_suite_result(ex, file)
        TestSuiteResult.new do |r|
          r.model = TestSuite.new do |s|
            s.source = file
            s.wsdl = '???'
            s.service = '???'
          end
          
          r.test_results = [
            TestResult.new do |test|
              test.name = '1'
              test.status = TestStatus.new :test_file_status => false, :test_text_status => { :error => true }
              test.error = { :message => ex.to_s, :backtrace => ex.backtrace }
            end
          ]
        end
      end
      
      def self._before_app
        return if HOOKS[:before_app].nil?
        
        HOOKS[:before_app].each do |block|
          block.call
        end
      end
      
      def self._after_app(result)
        return if HOOKS[:after_app].nil?
        
        HOOKS[:after_app].each do |block|
          block.call result
        end
      end
            
      attr_accessor :command, :ws_config
      attr_reader :test_app_result
    
    end

  end
end
