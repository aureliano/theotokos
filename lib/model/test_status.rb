module Model

  class TestStatus
  
    def initialize(opt = {})
      if block_given?
        yield self
      else
        _load_properties opt
      end
    end
    
    attr_accessor :test_file_status, :test_text_status
    
    def success?
      (
        (@test_file_status.nil? || @test_file_status == true) && 
        (@test_text_status.nil? || @test_text_status == true)
      )
    end
    
    def error?
      !success?
    end
    
    private
    def _load_properties(opt)
      @test_file_status = opt[:test_file_status]
      @test_text_status = opt[:test_text_status]
    end
  
  end

end
