# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name                   = "jekyll_version_plugin"
  spec.version                = "2.0.0"
  spec.authors                = ["Rob Murray"]
  spec.email                  = ["robmurray17@gmail.com"]
  spec.summary                = "A Liquid tag plugin for Jekyll that renders a version identifier for your Jekyll site, sourced from the git repository."
  spec.homepage               = "https://github.com/rob-murray/jekyll-version-plugin"
  spec.license                = "MIT"
  spec.required_ruby_version  = ">= 1.9.3"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.5"
end
