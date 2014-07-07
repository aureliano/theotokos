module Engine

  class SoapExecutor < Executor
  
    def initialize(test_suite)
      @test_suite = test_suite
      @count = 0
      @logger = Logger.create_logger self
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
    
    attr_accessor :test_suite
    
    private
    def _execute_test_suite
      res = TestSuiteResult.new do |r|
        r.model = @test_suite
        r.test_results = _execute
      end
      
      res
    end
    
    def _execute
    
    end
  
  end

end
