$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require 'requires.rb'

Gem::Specification.new do |s|
  s.name         = 'theotokos'
  s.version      = Theotokos::RELEASE_VERSION
  s.date         = Theotokos::RELEASE_DATE
  s.summary      = "theotokos-#{Theotokos::RELEASE_VERSION} Tool to easily test web services."
  s.description  = "A gem for web service testing. Allows easily create test suites using YAML as test model."
  s.authors      = ["Aurealino"]
  s.email        = 'aureliano.franca@hotmail.com'
  s.homepage     = 'https://github.com/aureliano/theotokos'
  s.license      = 'MIT'
  s.platform     = Gem::Platform::RUBY
  s.required_ruby_version = ">= 1.9.3"
  
  s.files        = `git ls-files`.split("\n").reject {|path| path =~ /\.gitignore$/ }
  s.test_files   = `git ls-files -- test/*`.split("\n")
  s.executables  = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.rdoc_options = ["--charset=UTF-8"]
  
  s.add_runtime_dependency 'logging', '~> 1.8.2'
  s.add_runtime_dependency 'savon', '2.5.1'
  s.add_runtime_dependency 'equivalent-xml', '~> 0.4.2'
end
