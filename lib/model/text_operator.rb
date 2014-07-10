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
    
    def to_hash
      Hash.new({
        :contains => @contains, :not_contains => @not_contains,
        :equals => @equals, :regex => @regex
      })
    end
    
    private
    def _load_properties(opt)
      @contains = opt[:contains]
      @not_contains = opt[:not_contains]
      @equals = opt[:equals]
      @regex = opt[:regex]
    end
  
  end

end
