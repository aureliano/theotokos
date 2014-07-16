module Theotokos
  module Engine

    class SoapExecutor < Executor
    
      def initialize
        @count = 0
        @logger = AppLogger.create_logger self
        yield self if block_given?
      end
      
      def execute
        return unless self.should_execute?
        @logger.info "Execute Soap Test '#{@test_suite.source}'"
        @logger.info "WSDL: #{@test_suite.wsdl}"
        @logger.info "Service: #{@test_suite.service}"
        
        self.before_suite @test_suite
        test_suite_result = _execute_test_suite      
        self.after_suite @test_suite, test_suite_result
        
        test_suite_result
      end
      
      private
      def _execute_test_suite
        res = TestSuiteResult.new do |r|
          r.model = @test_suite
          r.test_results = _execute
        end
        
        res
      end
      
      def _execute
        results = []
        @test_suite.tests.each do |test|
          @count += 1
          next if !@test_index.nil? && @test_index != @count
          next unless self.should_execute_test? test
          
          result = {}
          self.before_test test
          test_result = TestResult.new do |t|
            t.name = ((test.name.nil?) ? @count : test.name)
            t.description = test.description
            t.error_expected = test.error_expected
            t.tags = test.tags
          end
          
          res = SoapNet.send_request :wsdl => @test_suite.wsdl, :ws_config => @ws_config,
            :ws_security => test.ws_security, :service => @test_suite.service, :params => test.input
          test_result.test_expectation = test.output
          
          if res[:success] == false && !test_result.error_expected
            test_result.error = { :message => 'Send request failure', :backtrace => res[:xml] }
            test_result.status = TestStatus.new :error => true
            results << test_result
            
            @console_report.print test_result unless @console_report.nil?
            self.after_test test, test_result
            next
          elsif res[:success] == true && test_result.error_expected
            test_result.error = { :message => 'It was supposed to get an exception but nothing was caught.' }
            test_result.status = TestStatus.new :error => true
            results << test_result
            
            @console_report.print test_result unless @console_report.nil?
            self.after_test test, test_result
            next
          end
          
          test_result.test_actual = save_web_service_result res[:xml]
          test_res = validate_test_execution test.output, test_result.test_actual
          if test_res.instance_of? Model::TestStatus
            test_result.status = test_res
          else
            test_result.error = { :message => test_res.to_s, :backtrace => test_res.backtrace }
            test_result.status = TestStatus.new :error => true
          end
          
          results << test_result
          @console_report.print test_result unless @console_report.nil?
          self.after_test test, test_result
        end
        
        results
      end
    
    end

  end
end
