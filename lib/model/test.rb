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
    
    end
    
  end
end
