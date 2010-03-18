require "rubygems"

desc "Run the server in development mode with Thin web server, reloading on each request"
task :dev_run do |t|
  sh %{shotgun -I lib -r rubygems -s thin -p 4567 config.ru}
end

require "rake/testtask"
desc "Run tests"
Rake::TestTask.new(:test) do |t|
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
  t.warning = true
  t.ruby_opts << "-rrubygems"
  t.libs << "test"
end

task :default => :test
