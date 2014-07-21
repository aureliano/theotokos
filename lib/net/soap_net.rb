module Net

  class SoapNet
  
    def self.send_request(options)
      logger = AppLogger.create_logger self
      client = _savon_client options[:wsdl], options[:ws_config], options[:ws_security]
      service = options[:service].to_s.gsub(/(.)([A-Z])/,'\1_\2').downcase # snake_case
      xml = success = nil
      
      begin
        logger.debug "Send request to service '#{service}'"
        response = client.call service.to_sym, :message => options[:params]
        xml = response.xml
        success = true
      rescue Exception => ex
        return { :success => false, :xml => Nokogiri::XML(ex.http.body).to_xml } if ex.instance_of? Savon::SOAPFault      
      
        xml = Nokogiri::XML::Builder.new do |xml|
          xml.error do
            xml.message ex.to_s
            xml.backtrace ex.backtrace.join("\n    ")
          end
        end.to_xml
        success = false
      end
      
      logger.debug "Success on request? #{success}"
      { :success => success, :xml => xml }
    end
    
    def self._savon_client(wsdl_url, ws_config, ws_security)
      logger = AppLogger.create_logger self
      logger.debug "Prepare web service app client"
      
      params = {}
      params[:env_namespace] = ws_config.env_namespace if ws_config.env_namespace
      params[:namespaces] = ws_config.namespaces if ws_config.namespaces

      params[:ssl_verify_mode] = ws_config.ssl_verify_mode if ws_config.ssl_verify_mode
      params[:ssl_version] = ws_config.ssl_version if ws_config.ssl_version
      params[:ssl_cert_file] = ws_config.ssl_cert_file if ws_config.ssl_cert_file
      params[:ssl_cert_key_file] = ws_config.ssl_cert_key_file if ws_config.ssl_cert_key_file
      params[:ssl_ca_cert_file] = ws_config.ssl_ca_cert_file if ws_config.ssl_ca_cert_file
      params[:ssl_cert_key_password] = ws_config.ssl_cert_key_password if ws_config.ssl_cert_key_password
      
      logger.debug "Client config params for requesting service: #{params}"
      logger.debug "WS-Security params: #{ws_security}" if (!ws_security.nil? && !ws_security.empty?)
      
      Savon.client(params) do
        wsdl wsdl_url
        wsse_auth ws_security['login'], ws_security['password'], :digest if (!ws_security.nil? && !ws_security.empty?)
      end
    end
  
  end

end
