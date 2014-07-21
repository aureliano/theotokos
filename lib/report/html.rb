module Report

  class Html < Reporter
  
    def initialize
      config_locale
      @logger = AppLogger.create_logger self
    end
    
    def print(data)
      return if ENV['ENVIRONMENT'] == 'test'
      Dir.mkdir 'tmp' unless File.exist? 'tmp'
      Dir.mkdir ENV['ws.test.reports.path'] unless File.exist? ENV['ws.test.reports.path']

      @app = data[:app_result]
      @ws_config = data[:ws_config]
      @tags = data[:tags]
      @suite_pages = {}
      
      file = "#{ENV['ws.test.reports.path']}/index.html"
      File.open(file, 'w') {|file| file.write Helper.build_index_page(@app, @locale, @ws_config, @tags) }
      @logger.info " -- HTML report saved to #{file}" unless ENV['ENVIRONMENT'] == 'test'
      
      @app.suites.each do |suite|
        file = "#{ENV['ws.test.reports.path']}/#{suite.model.name}.html"
        @logger.debug " -> Save HTML suite page for '#{suite.model.name}' to '#{file}'"
        File.open(file, 'w') {|file| file.write Helper.build_suite_page @app, @locale, suite }
      end
      
      _copy_resources
      
      file
    end
    
    private
    def _copy_resources
      html_path = File.expand_path('../../../html', __FILE__)
      css_path = "#{ENV['ws.test.reports.path']}/css"
      Dir.mkdir css_path unless File.exist? css_path
      
      @logger.debug "Copy stylesheets to #{css_path}"
      FileUtils.cp "#{html_path}/bootstrap.min.css", css_path
      
      js_path = "#{ENV['ws.test.reports.path']}/js"
      Dir.mkdir js_path unless File.exist? js_path
      
      @logger.debug "Copy javascripts to #{js_path}"
      FileUtils.cp "#{html_path}/jquery.min.js", js_path
      FileUtils.cp "#{html_path}/bootstrap-collapse.js", js_path
      FileUtils.cp "#{html_path}/Chart.min.js", js_path
    end
  
  end

end
