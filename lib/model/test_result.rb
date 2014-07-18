module Theotokos
  module Model

    class TestResult
    
      def initialize
        @error_expected = skip = false
        yield self if block_given?
      end
      
      attr_accessor :name, :description, :tags, :status, :error, :test_expectation, :test_actual, :error_expected, :filter, :skip
    
      def to_hash
        { :name => @name, :description => @description, :tags => @tags, :status => ((@status) ? @status.to_hash : @status),
          :error => @error, :test_expectation => @test_expectation, :test_actual => @test_actual,
          :error_expected => @error_expected, :filter => ((@filter) ? @filter.to_hash : @filter), :skip => @skip }
      end
      
    end

  end
end
