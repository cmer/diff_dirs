require 'rake'
require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib' << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end
 
task :default => :test

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "diff_dirs"
    gemspec.summary = "Ruby helper to diff two directories"
    gemspec.email = "carl@carlmercier.com"
    gemspec.homepage = "http://github.com/cmer/diff_dirs"
    gemspec.description = "Ruby helper to diff two directories"
    gemspec.authors = ["Carl Mercier"]
    gemspec.files =  FileList["[A-Z]*", "{bin,generators,lib,test}/**/*"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end
