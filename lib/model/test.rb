module Theotokos
  module Model
        
    class Test
    
      def initialize
        yield self if block_given?
        
        @tags ||= []
        @input ||= {}
        @output ||= {}
        @ws_security ||= {}
        @error_expected = false
        
        _config_tags @tags
        _validation
      end
    
      attr_accessor :name, :description, :tags, :input, :output, :ws_security, :error_expected, :error
      
      def to_hash
        { :name => @name, :description => @description, :error_expected => @error_expected,
          :tags => @tags, :input => @input, :output => @output, :ws_security => @ws_security }
      end
      
      def has_tag?(tag)
        @tags.each {|t| return true if tag == t }
        false
      end
      
      private
      def _config_tags(t)
        self.tags = if t.instance_of? String
          t.split(/[,\s]/).select {|t| !t.empty? }
        elsif t.instance_of? Array
          t
        else
          []
        end
      end
      
      def _validation
        _validate_input
        _validate_output
        _validate_ws_security
      end
      
      def _validate_input
        raise 'Input of test model must be a Hash' unless @input.instance_of? Hash
      end
      
      def _validate_output
        raise 'Output of test model must be a Hash' unless @output.instance_of? Hash
        if @output['file']
          raise "test > output > file >> '#{@output['file']}' does not exist" unless File.exist? Helper.format_ws_output_path(@output['file'])
        end
        
        if @output['text']
          raise 'test > output > text must be a Hash' unless @output['text'].instance_of? Hash
          hash = @output['text']
          unless (hash.has_key?('equals') || hash.has_key?('contains') || hash.has_key?('not_contains') || hash.has_key?('regex'))
            raise 'test > output > text must have one o those keys [equals, contains, not_contains, regex]'
          end
        end
      end
      
      def _validate_ws_security
        raise 'Ws-security of test model must be a Hash' unless @ws_security.instance_of? Hash
        unless @ws_security.keys.empty?
          unless (@ws_security.has_key?('login') && @ws_security.has_key?('password'))
            raise 'test > output > ws-security must have configured login and password keys'
          end
        end
      end
    
    end
    
  end
end
