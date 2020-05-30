require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.test_files = FileList["tests/test_*.rb"]
end

task :default => :test
