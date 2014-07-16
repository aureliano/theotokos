module Report

  class Console < Reporter
    
    def print(object)
      case object.class.name
        when Theotokos::Model::TestResult.name then _print_test_result object
        when Theotokos::Model::TestSuiteResult.name then _print_test_suite_result object
        when Theotokos::Model::TestAppResult.name then _print_test_app_result object
        else puts "Console printing is not supported for objects of type #{object.class.name}"
      end
    end
    
    private
    def _print_test_result(test)
      @output = ''
      _append "Test case: ##{test.name}"
      _append "Test description: #{test.description}"
      _append "Tags: #{test.tags.join(', ')}" if test.tags
      _append "Test expectations."
      
      if test.test_expectation
        if test.test_expectation['file']
          file = test.test_expectation['file']
          _append " => File '#{file}'\n#{File.read(file)}"
          _append " => Status: #{test.status.test_file_status ? 'Passed' : 'Failed'}\n"
        end
        puts
        if test.test_expectation['text']
          exp = test.test_expectation['text']
          _append " => Text\n"

          exp.each do |k, v|
            _append "#{k}: #{v}"
            if test.status.test_text_status.nil?
              _append "Status: Not performed"
            else
              status = test.status.test_text_status[k.to_sym]
              _append "Status: #{status ? 'Passed' : 'Failed'}"
            end
          end
        end          
      end
      
      if test.error
        backtrace = ((test.error[:backtrace].instance_of? Array) ? test.error[:backtrace].join("\n") : test.error[:backtrace])
        _append "\n - Error message: #{test.error[:message]}"
        _append "\n - Error detail:\n#{backtrace}"
      else
        _append "\n- Found output."
        _append (test.test_actual) ? File.read(test.test_actual) : ''
      end
      
      _append "\n- Test case status: #{test.status.success? ? 'Success' : 'Fail'}"
      _append "\n------\n\n"
      
      @output
    end
    
    def _print_test_suite_result(suite)
      @output = ''
      _append "-" * 100
      _append "Total test success: #{suite.total_success}"
      _append "Total test failures: #{suite.total_failures}"
      
      @output
    end
    
    def _print_test_app_result(app)
      @output = ''
      _append "*" * 100
      _append "Total test suites success: #{app.total_success}"
      _append "Total test suites failures: #{app.total_failures}\n"
      
      if app.error?
        _append "*" * 100
        _append "- Broken tests"
        app.broken_suites.each do |suite|
          _append "Test suite: #{suite.model.source}\nTest cases: ##{suite.broken_tests.map {|t| t.name }.join(', #')}"
        end
      end
      
      @output
    end
    
    def _append(text)
      @output << "\n" unless @output.empty?
      @output << text
      puts text unless ENV['ENVIRONMENT'] == 'test'
    end
  
  end

end
