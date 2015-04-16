$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "acts_as_markable/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "acts_as_markable"
  s.version     = ActsAsMarkable::VERSION
  s.authors     = ["flowerwrong"]
  s.email       = ["sysuyangkang@gmail.com"]
  s.homepage    = "https://github.com/FlowerWrong"
  s.summary     = "Do your users want to add food, drinks, books, movies, and many other stuff to favorites?"
  s.description = "Marking system for rails applications."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency 'rails', '~> 4.2'

  s.add_development_dependency 'sqlite3', '~> 1.3'
  s.add_development_dependency 'awesome_print', '~> 1.6'
end
