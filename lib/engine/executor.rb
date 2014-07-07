module Engine

  class Executor
    
    protected
    def before(&block)
      @logger.info 'Playing Before Test'
      block.call if block_given?
    end
    
    def after(&block)
      @logger.info 'Playing After Test'
      block.call if block_given?
    end
  
  end

end
