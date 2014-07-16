module Theotokos
  module Engine

    class Parser
    
      def self.yaml_to_test_suite(source)
        Parser.hash_to_test_suite Parser.yaml_to_hash(source)
      end
    
      def self.yaml_to_hash(source)
        raise Exception, "File #{source} does not exist." unless File.exist? source
        YAML.load_file source
      end
      
      def self.hash_to_test_suite(hash)
        Model::TestSuite.new do |suite|
          suite.wsdl = hash['wsdl']
          suite.service = hash['service']
          suite.description = hash['description']
          suite.tags = hash['tags']
          
          suite.tests = hash['tests'].map do |te|
            Model::Test.new do |t|
              t.input = te['input']
              t.output = te['output']
              t.ws_security = te['ws-security']
              t.error_expected = te['error_expected']
            end
          end unless hash['tests'].nil?
        end
      end
    
    end

  end
end
