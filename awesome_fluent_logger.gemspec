require_relative 'lib/awesome_fluent_logger/version'

Gem::Specification.new do |spec|
  spec.name          = "awesome_fluent_logger"
  spec.version       = AwesomeFluentLogger::VERSION
  spec.authors       = ["windyakin"]
  spec.email         = ["windyakin@gmail.com"]

  spec.summary       = "Awesome logger with fluent-logger for Ruby"
  spec.description   = "This library can mimic Ruby's built-in Logger class to forward logs to fluent."\
    "You can use this library not only for Rails but also for pure-Ruby apps."
  spec.homepage      = "https://github.com/windyakin/awesome_fluent_logger"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0")

  spec.add_dependency 'fluent-logger', '~> 0.9'

  spec.add_development_dependency 'rspec', '~> 3.6'
  spec.add_development_dependency 'timecop'
  spec.add_development_dependency 'pry-byebug'

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/windyakin/awesome_fluent_logger"
  spec.metadata["changelog_uri"] = "https://github.com/windyakin/awesome_fluent_logger/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
