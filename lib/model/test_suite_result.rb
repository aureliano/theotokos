module Model

  class TestSuiteResult
  
    def initialize
      @success = false
      yield self if block_given?
    end
    
    attr_accessor :model, :test_results
    attr_reader :total_failures, :total_success
  
    def calculate_totals
      @total_failures = @total_success = 0
      return if @test_results.nil?
      
      @test_results.each do |res|
        next if res.status.nil?
        @total_failures += 1 if res.status.error?
        @total_success += 1 if res.status.success?
      end
      
      @success = @total_failures == 0
    end
    
    def success?
      @success
    end
    
    def total_tests
      (@test_results.nil?) ? 0 : @test_results.size
    end
    
  end

end
