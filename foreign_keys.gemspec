# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "foreign_keys/version"

Gem::Specification.new do |s|
  s.name        = "foreign_keys"
  s.version     = ForeignKeys::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Andreas Wurm"]
  s.email       = ["andreaswurm@gmx.de"]
  s.homepage    = ""
  s.summary     = "This gem adds foreign key support for ActiveRecord migrations."
  s.description = "This gem adds foreign key support for ActiveRecord migrations."


  s.add_dependency 'activerecord'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
