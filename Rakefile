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
