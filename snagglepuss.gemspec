# frozen_string_literal: true

require_relative "lib/snagglepuss/version"

Gem::Specification.new do |spec|
  spec.name = 'snagglepuss'
  spec.version = Snagglepuss::VERSION
  spec.authors = ['Travis Herrick']
  spec.email = ['tthetoad@gmail.com']

  spec.summary     = 'Exit your application gracefully with Snagglepuss'
  spec.description = 'Snagglepuss ensures you have useful information when your application exits unexpectedly'
  spec.homepage    = 'http://www.github.com/toadjamb/gems_snagglepuss'
  spec.required_ruby_version = '>= 2.6.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'http://www.github.com/toadjamb/gems_snagglepuss'
  spec.metadata['changelog_uri'] = 'http://www.github.com/toadjamb/gems_snagglepuss/blob/master/changelog.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'color_me_rad', '~> 0.0.4'
end
