source :rubygems

gem "json" if RUBY_VERSION < "1.9"
gem "rack"
gem "sinatra"

group :development do
  gem "shotgun"
end

group :development, :test do
  gem "contest"
  gem "rack-test"
  gem "redis", ">= 2.0.1"
  gem "thin"
end
