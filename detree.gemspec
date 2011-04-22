# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "detree/version"

Gem::Specification.new do |s|
  s.name        = "detree"
  s.version     = Detree::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Rafael Barbolo Lopes", "Rafael Ivan Garcia"]
  s.email       = ["tech@infosimples.com.br"]
  s.homepage    = "http://github.com/infosimples/detree"
  s.summary     = %q{Ruby gem for high level text parsing from HTML/XML}
  s.description = %q{Detree is able to parse text from HTML/XML, keeping its tree structure and indentation levels.}

  s.rubyforge_project = "detree"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
