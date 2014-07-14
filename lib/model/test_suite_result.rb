module Model

  class TestSuiteResult
  
    def initialize
      @success = false
      @broken_tests = []
      yield self if block_given?
    end
    
    attr_accessor :model, :test_results
    attr_reader :total_failures, :total_success, :broken_tests
  
    def calculate_totals
      @total_failures = @total_success = 0
      @broken_tests.clear
      return if @test_results.nil?
      
      @test_results.each do |res|
        next if res.status.nil?
        if res.status.error?
          @total_failures += 1
          @broken_tests << res
        end
        @total_success += 1 if res.status.success?
      end
      
      @success = @total_failures == 0
    end
    
    def success?
      @success
    end
    
    def error?
      !success?
    end
    
    def total_tests
      (@test_results.nil?) ? 0 : @test_results.size
    end
    
    def name
      return '' if @model.nil?
      
      regex = Regexp.new ENV['ws.test.models.path'].sub(/\/$/, '')
      name = @model.source.sub regex, ''
      name.sub! /^\//, ''
      
      name.sub('.yml', '').split('/').join('_')
    end
    
    def to_hash
      { :model => ((@model) ? @model.to_hash : @model),
      :test_results => ((@test_results) ? @test_results.map {|t| t.to_hash } : @test_results),
      :total_failures => @total_failures, :total_success => @total_success,
      :broken_tests => @broken_tests }
    end
    
  end

end
