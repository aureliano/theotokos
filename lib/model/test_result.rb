module Theotokos
  module Model

    class TestResult
    
      def initialize
        @error_expected = false
        yield self if block_given?
      end
      
      attr_accessor :name, :description, :tags, :status, :error, :test_expectation, :test_actual, :error_expected, :filter
    
      def to_hash
        { :name => @name, :description => @description, :tags => @tags, :status => ((@status) ? @status.to_hash : @status),
          :error => @error, :test_expectation => @test_expectation, :test_actual => @test_actual,
          :error_expected => @error_expected, :filter => ((@filter) ? @filter.to_hash : @filter) }
      end
      
    end

  end
end
