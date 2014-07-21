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
      @logger = AppLogger.create_logger self if @logger.nil?
      @logger.info "Localizing report to '#{ENV['ws.test.reports.locale']}' idiom"
      
      if ENV['ws.test.reports.locale'] == 'en'
        _config_default_locale
      else
        locale_file = File.join(ENV['ws.test.reports.locales.path'], ENV['ws.test.reports.locale'])
        unless File.exist? locale_file
          @logger.warn "Locale configuration file '#{locale_file}' for lacale '#{ENV['ws.test.reports.locale']}' does not exist"
          @logger.warn "Loading default locale for 'en' idiom"
          _config_default_locale
        else
          @locale = YAML.load_file File.join(ENV['ws.test.reports.locales.path'], ENV['ws.test.reports.locale'])
        end
      end
    end
    
    private
    def _config_default_locale
      @logger.debug 'Loading default locale: en'
      @logger.debug 'Looking for custom locale config file for en'
      
      default_locale_file = File.join(ENV['ws.test.reports.locales.path'], 'en')
      @locale = unless File.exist? default_locale_file
        @logger.debug "Custom locale config file for 'en' does not exist"
        @logger.debug "Loading defaul locale config file"
        YAML.load_file File.expand_path('../default_locale', __FILE__)
      else
        YAML.load_file default_locale_file
      end
    end
  
  end

end
