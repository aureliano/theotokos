module Model

  class TestResult
  
    def initialize
      @error_expected = false
      yield self if block_given?
    end
    
    attr_accessor :name, :status, :error, :test_expectation, :test_actual, :error_expected, :filter
  
    def to_hash
      Hash.new({
        :name => @name, :status => @status.to_hash, :error => @error,
        :test_expectation => @test_expectation, :test_actual => @test_actual,
        :error_expected => @error_expected, :filter => @filter.to_hash
      })
    end
    
  end

end
