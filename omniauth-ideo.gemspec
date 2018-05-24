lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "omniauth-ideo/version"

Gem::Specification.new do |gem|
  gem.add_dependency "oauth2",     "~> 1.1"
  gem.add_dependency "omniauth",   "~> 1.2"

  gem.add_development_dependency "bundler", "~> 1.0"

  gem.authors       = ["Josh Schwartzman"]
  gem.email         = ["jschwartzman@ideo.com"]
  gem.description   = "IDEO OAuth2 strategy for OmniAuth."
  gem.summary       = gem.description
  gem.homepage      = "https://github.com/ideo/omniauth-ideo"
  gem.licenses      = %w[MIT]

  gem.executables   = `git ls-files -- bin/*`.split("\n").collect { |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "omniauth-ideo"
  gem.require_paths = %w[lib]
  gem.version       = OmniAuth::Ideo::VERSION
end
