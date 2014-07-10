module Report

  class Html < Reporter
  
    def print(data)
      puts " -- HTML report saved to #{file}" unless ENV['ENVIRONMENT'] == 'test'
    end
  
  end

end
