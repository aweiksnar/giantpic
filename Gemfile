source "https://rubygems.org"
ruby "2.0.0"

gem 'sinatra', '1.4.3'
gem 'sinatra-flash'
gem 'data_mapper'
gem 'grape'

group :development, :test do
  gem "sqlite3"
  gem 'dm-sqlite-adapter'
  gem 'sinatra-reloader'
end

group :production do
  gem 'pg'
  gem 'dm-postgres-adapter'
end


