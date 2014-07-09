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
    attr_writer :error
    
    def success?
      return !@error unless @error.nil?
      
      if (@test_file_status.nil? && @test_text_status.nil?)
        nil
      elsif (@test_file_status == true)
        (@test_text_status == true || @test_text_status.nil?)
      elsif (@test_text_status == true)
        (@test_file_status == true || @test_file_status.nil?)
      else
        false
      end
    end
    
    def error?
      return @error unless @error.nil?      
      
      ok = success?
      ok.nil? ? nil : !ok
    end
    
    def to_s
      "Model::TestStatus @error: #{@error}, @test_file_status: #{@test_file_status}, @test_text_status: #{@test_text_status}"
    end
    
    private
    def _load_properties(opt)
      @test_file_status = opt[:test_file_status]
      @test_text_status = opt[:test_text_status]
      @error = opt[:error]
    end
  
  end

end
