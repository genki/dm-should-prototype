def sudo_gem(cmd)
  sh "#{SUDO} #{RUBY} -S gem #{cmd}", :verbose => false
end

desc "Install #{GEM_NAME} #{GEM_VERSION}"
task :install => [ :package ] do
  sudo_gem "install --local pkg/#{GEM_NAME}-#{GEM_VERSION} --no-update-sources"
end

desc "Uninstall #{GEM_NAME} #{GEM_VERSION}"
task :uninstall => [ :clobber ] do
  sudo_gem "uninstall #{GEM_NAME} -v#{GEM_VERSION} -Ix"
end

require 'rake/gempackagetask'

spec = Gem::Specification.new do |s|
  #s.rubyforge_project = RUBYFORGE_PROJECT
  s.name = GEM_NAME
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.rdoc", "LICENSE", 'TODO']
  s.summary = PROJECT_SUMMARY
  s.description = PROJECT_DESCRIPTION
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = PROJECT_URL
  s.add_dependency('dm-core', '>= 0.9.10')
  s.require_path = 'lib'
  s.files = %w(LICENSE README.rdoc Rakefile TODO) + Dir.glob("{lib,spec}/**/*")
end

Rake::GemPackageTask.new(spec) do |pkg|
	pkg.need_tar = true
  pkg.gem_spec = spec
end

desc "Generate a gemspec file"
task :gemspec do
  File.open("#{GEM_NAME}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end
