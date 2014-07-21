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
    
    attr_accessor :data, :locale
    
    def print
      raise Exception, 'Not supported operation for ' + self.class.name
    end
    
    protected
    def config_locale
      puts "Localizing report to '#{ENV['ws.test.reports.locale']}' idiom"
      
      if ENV['ws.test.reports.locale'] == 'en'
        puts 'Loading default locale: en'
        @locale = YAML.load_file File.expand_path('../default_locale', __FILE__)
      else
        @locale = YAML.load_file File.join(ENV['ws.test.reports.locales.path'], ENV['ws.test.reports.locale'])
      end
    end
  
  end

end
