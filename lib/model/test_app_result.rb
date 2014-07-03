module Model

  class TestAppResult
  
    def initialize
      @success = false
      yield self if block_given?
    end
    
    attr_accessor :suites
    attr_reader :total_failures, :total_success
    
    def calculate_totals
      @total_failures = @total_success = 0
      return if @suites.nil?
      
      @suites.each do |suite|
        suite.calculate_totals
        @total_failures += 1 if suite.error?
        @total_success += 1 if suite.success?
      end
      
      @success = @total_failures == 0
    end
    
    def success?
      @success
    end
    
    def error?
      !success?
    end
    
    def total_suites
      (@suites.nil?) ? 0 : @suites.size
    end
    
   end
    
end
