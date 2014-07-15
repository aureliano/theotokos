module Theotokos
  module Assertion

    class TestAssertion
    
      def self.compare_file(expected, actual)
        raise Exception, "File #{expected} does not exist" unless File.exist? expected
        raise Exception, "File #{actual} does not exist" unless File.exist? actual
        
        TestAssertion.compare_text File.read(expected), File.read(actual), :equals
      end
    
      def self.compare_text(expected, actual, assertion = :equals)
        case assertion
          when :equals then TestAssertion.assert_equals expected, actual
          when :contains then TestAssertion.assert_contains expected, actual
          when :not_contains then TestAssertion.assert_not_contains expected, actual
          when :regex then TestAssertion.assert_match expected, actual
          else nil
        end
      end
      
      def self.assert_equals(expected, actual)
        opts = { :element_order => false, :normalize_whitespace => true }
        EquivalentXml.equivalent?(expected, actual, opts)
      end
      
      def self.assert_contains(expected, actual)
        actual.to_s.include? expected.to_s
      end
      
      def self.assert_not_contains(expected, actual)
        !TestAssertion.assert_contains(expected, actual)
      end
      
      def self.assert_match(regex, actual)
        regex = Regexp.new(regex.to_s) unless regex.instance_of? Regexp
        !(regex =~ actual.to_s).nil?
      end
    
    end

  end
end
