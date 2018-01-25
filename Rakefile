require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: %i[spec rubocop]

desc 'Run Rubocop on our codebase'
task :rubocop do
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
end
