
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "activerecord/encryption/version"

Gem::Specification.new do |spec|
  spec.name          = "activerecord-encryption"
  spec.version       = Activerecord::Encryption::VERSION
  spec.authors       = ["alpaca-tc"]
  spec.email         = ["alpaca-tc@alpaca.tc"]

  spec.summary       = %q{Write a short summary, because RubyGems requires one.}
  spec.description   = %q{Write a longer description or delete this line.}
  spec.homepage      = "https://github.com/alpaca-tc/activerecord-encryption"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rubocop", '~> 0.53.0'
  spec.add_development_dependency "guard-rspec", '~> 4.7.3'
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
