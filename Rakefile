# coding: utf-8

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

namespace :redis do
  REDIS_DIR = File.expand_path("test", File.dirname(__FILE__))
  REDIS_CNF = File.join(REDIS_DIR, "redis_test.conf")
  REDIS_PID = File.join(REDIS_DIR, "data", "redis.pid")

  desc "Start Redis server for tests"
  task :start do
    unless File.exists? REDIS_PID
      system "redis-server #{REDIS_CNF}"
    end
  end

  desc "Stop Redis server for tests"
  task :stop do
    if File.exists? REDIS_PID
      system "kill #{File.read(REDIS_PID)}"
      system "rm #{REDIS_PID}"
    end
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

desc "Run tests with Redis server starting and stopping"
task :test_with_redis => [:"redis:start", :test, :"redis:stop"]

task :default => :test_with_redis
