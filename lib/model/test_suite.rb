module Model
      
  class TestSuite
  
    def initialize(opt = {})
      if block_given?
        yield self
        _config_tags @tags
      else
        _load_properties opt
      end
      @tests ||= Array.new      
    end
    
    attr_accessor :source, :wsdl, :service, :tags, :tests
    
    def validate_model!
      raise Exception, 'WS test model must be provided.' if @source.nil? || @source.empty?
      raise Exception, "WSDL's URL must be provided." if @wsdl.nil? || @wsdl.empty?
      raise Exception, 'Service name (service to be tested) must be provided.' if @service.nil? || @service.empty?
    end
    
    private
    def _load_properties(opt)
      self.source = opt[:source]
      self.wsdl = opt[:wsdl]
      self.service = opt[:service]
      
      _config_tags opt[:tags]
      @tests = _load_tests opt[:tests]
    end
    
    def _config_tags(t)
      self.tags = if t.instance_of? String
        t.split(/[,\s]/).select {|t| !t.empty? }
      elsif t.instance_of? Array
        t
      else
        []
      end
    end
    
    def _load_tests(array)
      array ||= []
      data = []
      array.each do |test|
        data << Test.new do |t|
          t.input = test['input']
          t.output = test['output']
          t.ws_security = test['ws-security']
        end
      end
      
      data
    end
  
  end
  
end
