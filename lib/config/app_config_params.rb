module Configuration

  class AppConfigParams
  
    def self.load_app_config_params
      params = _get_config_hash
      ENV['ws.config.path'] = params['ws.config.path'] ||= 'resources/config/ws-config.yml'
    end
    
    def self._get_config_hash
      if ENV['ENVIRONMENT'] == 'test'
        ((ENV['app.cfg.path']) ? YAML.load_file(ENV['app.cfg.path']) : {})        
      else
        ((File.exist? 'app-cfg.yml') ? YAML.load_file('app-cfg.yml') : {})
      end
    end
  
  end

end
