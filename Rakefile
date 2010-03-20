SERVER_PORT = 4567

namespace :run do
  desc "Run the server with Thin web server, reloading on each request"
  task :dev do
    sh %{shotgun -r rubygems -p #{SERVER_PORT} -s thin config.ru}
  end

  desc "Run the server with Thin web server"
  task :thin do
    sh %{thin -r rubygems -p #{SERVER_PORT} -R config.ru start}
  end
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
