require 'rake/testtask'

# Excute unit tests
Rake::TestTask.new do |tester|
  puts 'Define environment to "test"'
  ENV['ENVIRONMENT'] = 'test'
  
  test_dir = "#{Dir.pwd}/test/unit/**/*.rb"
  puts "Loading tests from #{test_dir}"
  test_files = Dir.glob(test_dir).map {|file| file }
  puts

  tester.name = 'test:unit'
  tester.libs << "test"
  tester.test_files = test_files
  tester.verbose = true
end

desc 'Install this project locally as a Gem'
task :install_locally do
  Rake::Task['test:unit'].execute
  
  puts `gem build theotokos.gemspec`
  version = ''
  `ls | grep theotokos-`.to_s.split("\n").each do |f|
    v = f.sub('theotokos-', '').sub('.gem', '')
    version = v if v > version
  end
  puts `gem install theotokos-#{version}.gem`
end
