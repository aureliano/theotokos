module Theotokos
  module Helper

    def parse_cmd_options
      command = Execution.new
      
      opts = OptionParser.new do |opts|
        opts.banner = "Theotokos: a tool for web service testing"
        opts.define_head "Usage: theotokos [path:test_index] [options]"
        opts.separator ""
        opts.separator "Examples:"
        opts.separator " theotokos"
        opts.separator " theotokos resources/ws-test-model/project_xpto"
        opts.separator " theotokos resources/ws-test-model/project_xpto/web_service_test.yml"
        opts.separator " theotokos resources/ws-test-model/project_xpto/web_service_test.yml:1"
        opts.separator " theotokos -r console html json -t foo"
        opts.separator ""
        opts.separator "Options:"

        opts.on('-t', "--tags t1,t2,t3", Array, 'Specify test tags') do |tags|
          command.tags = tags
        end

        opts.on("-r", "--report-formats r1,r2,r3", Array, "Output test report formats. Must be one of [console, html, json]") do |formats|
          params = []
          formats.each do |f|
            raise "Supported report formats are: [console, html, json]. Found '#{f}' in [#{formats.join(', ')}]" unless ['console', 'html', 'json'].include? f
            params << f.to_sym
          end
          command.report_formats = params
        end

        opts.on_tail("-h", "--help", "Show this message") do
          puts opts
          exit
        end

        opts.on_tail("-v", "--version", "Show version") do
          puts "theotokos #{Theotokos::VERSION}"
          exit
        end
      end
      
      begin
        opts.parse!
        test_models_path = ARGV.pop
        match = /.yml:(\d+)$/.match(test_models_path)
        
        command.test_index = match.captures.first.to_i unless match.nil?      
        command.execution_path = test_models_path.sub(/:(\d+)$/, '') if test_models_path
        
        command
      rescue Exception => ex      
        puts " - Error: #{ex}" unless ex.instance_of? SystemExit
        exit -1
      end
    end

    def diff_time(inicio, fim)
      diferenca = (fim - inicio)
      s = (diferenca % 60).to_i
      m = (diferenca / 60).to_i
      h = (m / 60).to_i

      if s > 0
        "#{(h < 10) ? '0' + h.to_s : h}:#{(m < 10) ? '0' + m.to_s : m}:#{(s < 10) ? '0' + s.to_s : s}"
      else
        format("%.5f", diferenca) + " s."
      end
    end
    
    class << self
      def format_ws_model_path(file)
        format_app_path 'ws.test.models.path', file
      end
      
      def format_ws_output_path(file)
        format_app_path 'ws.test.output.files.path', file
      end
      
      def format_app_path(key, file)
        f = file.sub Regexp.new("^#{ENV[key]}"), ''
        File.join(ENV[key], f)
      end
    end

  end
end
