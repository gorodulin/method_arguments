# frozen_string_literal: true

require_relative "lib/method_arguments/version"

Gem::Specification.new do |spec|
  spec.name          = "ruby-method-arguments"
  spec.version       = MethodArguments::VERSION
  spec.authors       = ["Vladimir Gorodulin"]
  spec.email         = ["ru.hostmaster@gmail.com"]
  spec.summary       = "Read method arguments and assign instance variables"
  spec.description   = <<~DESC
                        The 'method_arguments' gem simplifies the process of setting object attributes from method arguments in Ruby.
                        It introduces a streamlined approach to assign instance variables directly from method arguments with minimal boilerplate code.
                        This utility is especially useful in constructors or methods with numerous parameters, enhancing code readability and maintainability.
                        DESC
  spec.homepage      = "https://github.com/gorodulin/method_arguments"
  spec.license       = "MIT"

  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0")

  spec.metadata = {
    "changelog_uri" => "https://github.com/gorodulin/method_arguments/CHANGELOG.md",
    "homepage_uri" => spec.homepage,
    "source_code_uri" => "https://github.com/gorodulin/method_arguments",
    "rubygems_mfa_required" => "true",
  }

  spec.files = Dir.glob("lib/**/*") + %w[README.md]
  spec.require_paths = ["lib"]
  spec.add_development_dependency "rspec", "~> 3.1"
end
