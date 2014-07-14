module Model

  class TestAppResult
  
    def initialize
      @success = false
      @broken_suites = []
      yield self if block_given?
    end
    
    attr_accessor :suites, :date_report
    attr_reader :total_failures, :total_success, :broken_suites
    
    def calculate_totals
      @total_failures = @total_success = 0
      @broken_suites.clear
      return if @suites.nil?
      
      @suites.each do |suite|
        suite.calculate_totals
        if suite.error?
          @total_failures += 1
          @broken_suites << suite
        end
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
    
    def total_test_cases
      return 0 if @suites.nil?
      
      total = @suites.reduce {|sum, suite| sum += suite.test_results.size }
      (total.nil?) ? 0 : total
    end
    
    def to_hash
      { :total_failures => @total_failures, :total_success => @total_success, :date_report => @date_report,
        :broken_suites => ((@broken_suites) ? @broken_suites.map {|s| s.to_hash } : @broken_suites),
        :suites => ((@suites) ? @suites.map {|s| s.to_hash } : @suites) }
    end
    
   end
    
end
