# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{diff_dirs}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Carl Mercier"]
  s.date = %q{2009-05-12}
  s.description = %q{Ruby helper to diff two directories}
  s.email = %q{carl@carlmercier.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "lib/diff_dirs.rb",
     "test/diff_dirs_test.rb",
     "test/test_helper.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/cmer/diff_dirs}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{diffdirs}
  s.rubygems_version = %q{1.3.2}
  s.summary = %q{Ruby helper to diff two directories}
  s.test_files = [
    "test/diff_dirs_test.rb",
     "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
