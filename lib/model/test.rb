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
  
  end
  
end
