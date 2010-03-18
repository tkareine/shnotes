require "rubygems"

desc "Run the server in development mode with Thin web server, reloading on each request"
task :dev_run do |t|
  sh %{shotgun -I lib -r rubygems -s thin -p 4567 config.ru}
end
