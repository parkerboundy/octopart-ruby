# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "octopart-ruby"
  gem.homepage = "http://github.com/parkerboundy/octopart-ruby"
  gem.license = "MIT"
  gem.summary = "Ruby wrapper for the Octopart API"
  gem.description = "Ruby wrapper for the Octopart API"
  gem.email = "parkerboundy@gmail.com"
  gem.authors = ["Parker Boundy"]  
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = false
end


task :default => :test

require 'yard'
YARD::Rake::YardocTask.new
