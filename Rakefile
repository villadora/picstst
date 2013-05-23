require 'bundler'
Bundler::GemHelper.install_tasks

task :test do
  $: << 'lib'
  require 'minitest/autorun'
  require 'picsts'
  Dir['./test/**/test_*.rb'].each { |test| require test }
end

task :default => :test