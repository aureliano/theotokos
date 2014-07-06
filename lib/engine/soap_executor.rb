module Engine

  class SoapExecutor
  
    def initialize(test_suite)
      @test_suite = test_suite
      @logger = Logger.create_logger self
    end
    
    def execute
      @logger.info "Executa Soap Test '#{@test_suite.source}'"
      @logger.info "WSDL: #{@test_suite.wsdl}"
      @logger.info "Service: #{@test_suite.service}"
    end
  
  end

end
