# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "gmusic/version"

Gem::Specification.new do |s|
  s.name        = "gmusic"
  s.version     = Gmusic::VERSION
  s.authors     = ["towerhe", "Jeweller-Tsai"]
  s.email       = ["towerhe@gmail.com", "jiangnan34@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Gmusic is a CLI app to interact with music.g.cn}
  s.description = %q{Gmusic provides a CLI and a series of APIs to interact wiht music.g.cn}

  s.rubyforge_project = "gmusic"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_dependency "thor", "~>0.14.6"
  s.add_dependency "command_line_reporter", "3.2.1"
  s.add_dependency "mechanize", "~>2.4"
  s.add_dependency "em-http-request", "~>1.0.2"
  s.add_dependency "em-synchrony", "~>1.0.1"
  s.add_dependency "confstruct", "~>0.2.2"

  s.add_development_dependency "rspec", "~>2.8.0"
  s.add_development_dependency "cucumber", "~>1.1.4"
  s.add_development_dependency "aruba", "0.4.11"
  s.add_development_dependency "fakeweb", "1.3.0"
end
