module Model

  class TextOperator
  
    def initialize(opt = {})
      if block_given?
        yield self
      else
        _load_properties opt
      end
    end
    
    attr_accessor :contains, :not_contains, :equals, :regex
    
    private
    def _load_properties(opt)
      @contains = opt[:contains]
      @not_contains = opt[:not_contains]
      @equals = opt[:equals]
      @regex = opt[:regex]
    end
  
  end

end
