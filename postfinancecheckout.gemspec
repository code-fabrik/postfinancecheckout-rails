require_relative "lib/postfinancecheckout/version"

Gem::Specification.new do |spec|
  spec.name        = "postfinancecheckout-rails"
  spec.version     = Postfinancecheckout::VERSION
  spec.authors     = ["Lukas_Skywalker"]
  spec.email       = ["lukas.diener@hotmail.com"]
  spec.homepage    = "https://github.com/code-fabrik/postfinancecheckout"
  spec.summary     = "Postfinance Checkout for Rails"
  spec.description = "Simple integration of Postfinance Checkout for Rails applications"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/code-fabrik/postfinancecheckout"
  spec.metadata["changelog_uri"] = "https://raw.githubusercontent.com/code-fabrik/postfinancecheckout/master/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.6"
  spec.add_dependency "postfinancecheckout-ruby-sdk", ">= 3.3.0"
end
