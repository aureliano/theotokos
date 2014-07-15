module Theotokos
  module Model
        
    class Test
    
      def initialize
        yield self if block_given?
        
        @input ||= {}
        @output ||= {}
        @ws_security ||= {}
        @error_expected = false
      end
    
      attr_accessor :input, :output, :ws_security, :error_expected, :error
      
      def to_hash
        { :error_expected => @error_expected, :input => @input, :output => @output, :ws_security => @ws_security }
      end
    
    end
    
  end
end
