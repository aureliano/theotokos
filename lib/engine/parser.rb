module Engine

  class Parser
  
    def self.parse_yaml(source)
      raise Exception, "File #{source} does not exist." unless File.exist? source
      YAML.load_file source
    end
  
  end

end
