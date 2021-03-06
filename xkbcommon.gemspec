# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xkbcommon/version'

Gem::Specification.new do |spec|
  spec.name          = "xkbcommon"
  spec.version       = Xkbcommon::VERSION
  spec.authors       = ["Christopher Aue"]
  spec.email         = ["mail@christopheraue.net"]

  spec.summary       = %q{xkbcommon bindings for ruby}
  spec.homepage      = "https://github.com/christopheraue/ruby-xkbcommon"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "libxkbcommon", "~> 1.0"
  spec.add_dependency "uinput", "~> 1.0"
end
