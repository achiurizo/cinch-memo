# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cinch/plugins/memo/version"

Gem::Specification.new do |s|
  s.name        = "cinch-memo"
  s.version     = Cinch::Plugins::Memo::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Arthur Chiu"]
  s.email       = ["mr.arthur.chiu@gmail.com"]
  s.homepage    = "https://github.com/achiu/cinch-memo"
  s.summary     = %q{Memo Plugin for Cinch}
  s.description = %q{Give your Cinch bot memo functionality!}

  s.rubyforge_project = "cinch-memo"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency 'cinch', '~>1.1.1'
  s.add_dependency 'json'
  s.add_dependency 'redis' 
  s.add_development_dependency 'riot',    '~>0.12.0'
  s.add_development_dependency 'mocha',   '~>0.9.10'
  s.add_development_dependency 'timecop', '~>0.3.5'
end
