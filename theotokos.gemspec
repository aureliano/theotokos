$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require 'requires.rb'

Gem::Specification.new do |s|
  s.name         = 'theotokos'
  s.version      = Theotokos::VERSION
  s.date         = '2014-07-15'
  s.summary      = "theotokos-#{Theotokos::VERSION} Tool to easily test web services."
  s.description  = "A gem for web service testing. Allows easily create test suites using YAML as test model."
  s.authors      = ["Aurealino"]
  s.email        = 'aureliano.franca@hotmail.com'
  s.homepage     = 'https://github.com/aureliano/ws-test'
  s.license      = 'GPL'
  s.platform     = Gem::Platform::RUBY
  s.required_ruby_version = ">= 1.9.3"
  
  s.files        = `git ls-files`.split("\n").reject {|path| path =~ /\.gitignore$/ }
  s.test_files   = `git ls-files -- test/*`.split("\n")
  s.executables  = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.rdoc_options = ["--charset=UTF-8"]
end
