module Theotokos
  module Configuration

    class AppLogger
    
      @@appenders = []
    
      def self.add_stdout_logger
        Logging.appenders.stdout(
          :level => ENV['logger.stdout.level'].to_sym,
          :layout => Logging::Layouts::Pattern.new(:date_pattern => ENV['logger.stdout.layout.date_pattern'], :pattern => ENV['logger.stdout.layout.pattern'])
        )
        
        @@appenders << 'stdout' unless @@appenders.include? 'stdout'
      end
      
      def self.add_rolling_file_logger
        dir = File.dirname ENV['logger.rolling_file.file']
        FileUtils.mkdir_p dir unless File.exist? dir
        
        Logging.appenders.rolling_file(
          ENV['logger.rolling_file.file'],
          :level => ENV['logger.rolling_file.level'].to_sym,
          :layout => Logging::Layouts::Pattern.new(:date_pattern => ENV['logger.rolling_file.date_pattern'], :pattern => ENV['logger.rolling_file.pattern'])
        )
        
        @@appenders << ENV['logger.rolling_file.file'] unless @@appenders.include? ENV['logger.rolling_file.file']
      end
      
      def self.create_logger(source = nil)
        if @@appenders.empty?
          puts 'WARNING! There is no appender specified.'
          return nil
        end
        
        logger = Logging.logger[source ||= self]
        logger.add_appenders @@appenders
        
        return logger
      end
    
    end

  end
end
