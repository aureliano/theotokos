module Model

  class TestSuite
  
    def initialize(opt = {})
      @source = opt[:source]
      @wsdl = opt[:wsdl]
      @service = opt[:service]
      
      @tags = if opt[:tags].instance_of? String
        opt[:tags].split(/[,\s]/).select {|t| !t.empty? }
      elsif opt[:tags].instance_of? Array
        opt[:tags]
      else
        []
      end
    end
    
    attr_accessor :source, :wsdl, :service, :tags, :tests
  
  end
  
end
