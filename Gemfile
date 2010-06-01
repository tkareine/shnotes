source :rubygems

gem "json" if RUBY_VERSION < "1.9"
gem "rack"
gem "sinatra"

gem "redis", ">= 2.0.1", :group => [:production_with_redis, :development, :test]

group :development do
  gem "shotgun"
end

group :development, :test do
  gem "contest"
  gem "rack-test"
  gem "thin"
end
