module Theotokos
  module Engine

    class Executor
      
      attr_accessor :test_suite, :test_index, :ws_config, :tags_input, :console_report
      
      protected
      def save_web_service_result(data)
        Dir.mkdir 'tmp' unless File.exist? 'tmp'
        file_name = "tmp/#{@test_suite.name}_#{@count}.xml"
        @logger.info "Web service response saved to #{file_name}"
      
        File.open(file_name, 'w') {|file| file.write data }
        file_name
      end
      
      def should_execute?
        return true if @tags_input.nil?
        
        @tags_input.each do |tag|
          return true if @test_suite.has_tag? tag
        end
        
        false
      end
      
      def should_execute_test?(test)
        return true if @tags_input.nil?
        
        @tags_input.each do |tag|
          return true if test.has_tag? tag
        end
        
        false
      end
      
      def validate_test_execution(expected_output, outcoming_file)
        return TestStatus.new :error => false if expected_output.nil?
        
        begin
          res = {}
          
          if expected_output['file']
            file = if expected_output['file'].start_with?(ENV['ws.test.output.files.path'])
               expected_output['file']
            else
              "#{ENV['ws.test.output.files.path']}/#{expected_output['file']}"
            end
            res[:file] = TestAssertion.compare_file file, outcoming_file
          end
          
          if expected_output['text']
            res[:text] = {}
            assertions = _get_assertions expected_output['text']
            
            assertions.each do |assertion|
              res[:text][assertion] = TestAssertion.compare_text expected_output['text'][assertion.to_s], File.read(outcoming_file), assertion
            end
          end
          
          return TestStatus.new :test_file_status => res[:file], :test_text_status => res[:text]
        rescue Exception => ex
          stack = ex.backtrace.join "\n"
          @logger.warn "Test validation has failed for test ##{@count}: #{ex.to_s}\n#{stack}"
          
          return ex
        end
      end
      
      def before_suite(test_suite)
        @logger.debug 'Playing Before Suite'
        return if HOOKS[:before_suite].nil?
        
        HOOKS[:before_suite].each do |block|
          block.call test_suite
        end
      end
      
      def after_suite(test_suite, test_suite_result)
        @logger.debug 'Playing After Suite'
        return if HOOKS[:after_suite].nil?
        
        test_suite_result.calculate_totals
        HOOKS[:after_suite].each do |block|
          block.call test_suite, test_suite_result
        end
      end
      
      def before_test(test)
        @logger.debug 'Playing Before Test'
        return if HOOKS[:before_test].nil?
        
        HOOKS[:before_test].each do |block|
          block.call test
        end
      end
      
      def after_test(test, test_result)
        @logger.debug 'Playing After Test'
        return if HOOKS[:after_test].nil?
        
        HOOKS[:after_test].each do |block|
          block.call test, test_result
        end
      end
      
      private
      def _get_assertions(hash)
        assertions = []
        ['equals', 'contains', 'not_contains', 'regex'].each do |assertion|
          next if hash[assertion].nil?
          
          assertions << case assertion
            when 'equals' then :equals
            when 'contains' then :contains
            when 'not_contains' then :not_contains
            when 'regex' then :regex
          end
        end
        
        assertions
      end
    
    end

  end
end
