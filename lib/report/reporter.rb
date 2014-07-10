module Report

  class Reporter
  
    def initialize
      yield self if block_given?
    end
  
    def self.create_reporter(report_type = :console)
      case report_type.to_sym
        when :console then Console.new
        when :json then Json.new
        when :html then Html.new
        else nil
      end
    end
    
    attr_accessor :data
    
    def print
      raise Exception, 'Not supported operation for ' + self.class.name
    end
  
  end

end
