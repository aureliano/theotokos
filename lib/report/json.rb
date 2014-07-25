module Theotokos
    module Report

    class Json < Reporter
    
      def print(data)
        Dir.mkdir 'tmp' unless File.exist? 'tmp'
        Dir.mkdir ENV['ws.test.reports.path'] unless File.exist? ENV['ws.test.reports.path']
        
        file = "#{ENV['ws.test.reports.path']}/report.json"
        json = ((data.nil?) ? {} : data.to_hash.to_json)
        File.open(file, 'w') {|file| file.write json }
        
        puts " -- JSON report saved to #{file}" unless ENV['ENVIRONMENT'] == 'test'
        file
      end
    
    end

  end
end
