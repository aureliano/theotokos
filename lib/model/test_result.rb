module Model

  class TestResult
  
    def initialize
      @error_expected = false
      yield self if block_given?
    end
    
    attr_accessor :name, :status, :error, :test_expectation, :test_actual, :error_expected, :filter
  
  end

end
