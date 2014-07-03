module Model
      
  class Test
  
    def initialize
      @input = {}
      @output = {}
      @ws_security = {}
      
      yield self if block_given?
    end
  
    attr_accessor :input, :output, :ws_security
  
  end
  
end
