require File.expand_path '../requires.rb', __FILE__

module Theotokos

  class Theotokos
  
    def initialize
      yield self if block_given?
      
      AppConfigParams.load_app_config_params unless ENV['app.config.params.loaded'] == 'true'
      ENV['ws.test.reports.locale'] = @execution.internationalization unless @execution.internationalization.nil?
      AppLogger.add_stdout_logger
      AppLogger.add_rolling_file_logger if AppConfigParams.rolling_file_logger_defined?
      @logger = AppLogger.create_logger self
    end
    
    attr_accessor :execution, :ws_config
    attr_reader :test_app_result
    
    def execute
      @logger.debug ' >>>>>>>>>>>>> Initialize WS test application...'
      @logger.info "Mapping test models in #{((@execution.execution_path) ? @execution.execution_path : ENV['ws.test.models.path'])}"
      
      @execution.test_files = ExecutionInitializer.load_test_models @execution.execution_path
      @logger.debug "Got test models: #{@execution.test_files.join(', ')}"
      
      _execute
    end
    
    def save_reports
      @execution.report_formats.reject {|e| e == :console }.each do |format|
        case format
          when :html then Reporter.create_reporter(format).print(:app_result => @test_app_result, :ws_config => @ws_config, :tags => @execution.tags)
          when :json then Reporter.create_reporter(format).print @test_app_result
        end
      end
    end
    
    private
    def _execute
      @logger.info 'Initialize executors'
      init_time = Time.now
      
      main_executor = ExecutionInitializer.new do |e|
        e.command = @execution
        e.ws_config = @ws_config
      end
      
      main_executor.init_executors
      @test_app_result = main_executor.test_app_result
      @test_app_result.date_report = init_time
    end
    
  end

end
