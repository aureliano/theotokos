module Report

  class ChartFactory
    
    def self.pie_chart(opt)
      total = opt[:total_success].to_i + opt[:total_failures].to_f
      success = ((opt[:total_success].to_i * 100) / total).to_f.round 2
      failures = ((opt[:total_failures].to_i * 100) / total).to_f.round 2
      
      str = "[{ value: #{success}, color: \"#1A0B9C\", highlight: \"#1E0CC0\", label: \"Success (%)\"},"
      str << "{ value : #{failures}, color : \"#BF1717\", highlight: \"#D71515\", label: \"Failures (%)\"}]"
      
      ChartFactory._template :id => opt[:id], :data => str, :type => :pie
    end
    
    def self.bar_chart(opt)
      # Not implemented yet
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
