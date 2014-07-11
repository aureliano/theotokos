module Model

  class Execution
  
    def initialize
      @report_formats = [:console]
      yield self if block_given?
    end
    
    attr_accessor :test_files, :test_index, :report_formats, :tags, :execution_path
  
  end

end
