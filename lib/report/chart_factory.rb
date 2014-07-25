module Theotokos
  module Report

    class ChartFactory
      
      def self.success_failure_chart(opt)
        total = opt[:total_success].to_i + opt[:total_failures].to_f
        success = ((opt[:total_success].to_i * 100) / total).to_f.round 2
        failures = ((opt[:total_failures].to_i * 100) / total).to_f.round 2
        
        str = "[{ value: #{success}, color: \"#1A0B9C\", highlight: \"#1E0CC0\", label: \"Success (%)\"},"
        str << "{ value : #{failures}, color : \"#BF1717\", highlight: \"#D71515\", label: \"Failures (%)\"}]"
        
        ChartFactory._template :id => opt[:id], :data => str, :type => :pie
      end
      
      def self.totals_tags_chart(opt)
        stats = opt[:stats]
        str = <<-eos
  {
    labels: ["#{stats.keys.join('","')}"],
    datasets: [{
      fillColor: "rgba(151,187,205,0.5)",
      strokeColor: "rgba(151,187,205,0.8)",
      highlightFill: "rgba(151,187,205,0.75)",
      highlightStroke: "rgba(151,187,205,1)",
      data: [#{stats.map {|k, v| stats[k][:total] }.join(',')}]
    }]    
  }
  eos
        ChartFactory._template :id => opt[:id], :data => str, :type => :bar
      end
      
      def self.stats_tags_chart(opt)
        stats = opt[:stats]
        str = <<-eos
  {
    labels: ["#{stats.keys.join('","')}"],
    datasets: [{
      fillColor: "rgba(220,220,220,0.5)",
      strokeColor: "rgba(220,220,220,0.8)",
      highlightFill: "rgba(220,220,220,0.75)",
      highlightStroke: "rgba(220,220,220,1)",
      data: [#{stats.keys.map {|k| 100 }.join(',')}]
    },
    {
      fillColor: "rgba(151,187,205,0.5)",
      strokeColor: "rgba(151,187,205,0.8)",
      highlightFill: "rgba(151,187,205,0.75)",
      highlightStroke: "rgba(151,187,205,1)",
      data: [#{stats.map {|k, v| stats[k][:stat] }.join(',')}]
    }]    
  }
  eos
        ChartFactory._template :id => opt[:id], :data => str, :type => :bar
      end
      
      def self._template(opt)
  <<-eos
    var data = #{opt[:data]};

    var chart = document.getElementById("#{opt[:id]}").getContext("2d");
    new Chart(chart).#{opt[:type].to_s.capitalize}(data, {});
  eos
      end
    
    end

  end
end
