module Engine

  class SoapExecutor < Executor
  
    def initialize
      @count = 0
      @logger = AppLogger.create_logger self
      yield self if block_given?
    end
    
    def execute
      @logger.info "Executa Soap Test '#{@test_suite.source}'"
      @logger.info "WSDL: #{@test_suite.wsdl}"
      @logger.info "Service: #{@test_suite.service}"
      
      before      
      test_suite_result = _execute_test_suite      
      after
      
      test_suite_result
    end
    
    attr_accessor :test_suite, :test_index, :ws_config
    
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
        test_result = TestResult.new
        result = {}
        
        @count += 1
        next if !@test_index.nil? && @test_index != @count
        
        test_result.name = @count
        test_result.error_expected = test.error_expected
        
        res = SoapNet.send_request :wsdl => @test_suite.wsdl, :ws_config => @ws_config, :ws_security => test.ws_security, :service => @test_suite.service
        
        if res[:success] == false && !test_result.error_expected
          results << test_result
          next
        elsif res[:success] == true && test_result.error_expected
          test_result.error = { :message => 'It was supposed to get an exception but nothing was caught.' }
          test_result.status = TestStatus.new :test_file_status => false, :test_text_status => false
          results << test_result
          next
        end
        
        results << test_result
      end
      
      results
    end
  
  end

end
