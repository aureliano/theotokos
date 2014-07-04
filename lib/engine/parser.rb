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
        suite.tags = hash['tags']
        suite.tests = hash['tests']
      end
    end
  
  end

end
