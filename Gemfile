source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails'



# Use SCSS for stylesheets
gem 'sass-rails'
gem 'bootstrap-sass'
gem 'formtastic', git: 'git://github.com/justinfrench/formtastic.git', branch: '2.3-stable'
gem 'formtastic-bootstrap'
gem 'jquery-datatables-rails', git: 'git://github.com/rweng/jquery-datatables-rails.git'
gem 'jquery-ui-rails'

# Deployment gems
gem 'capistrano'
gem 'capistrano-rails'
gem 'capistrano-ext'
gem 'capistrano-bundler'
gem 'capistrano-rvm'
group :production do
gem 'pg'
  gem "activerecord-postgresql-adapter"
  gem 'passenger'
end

group :development do
  gem 'sqlite3'
end

# Dump data to seed
gem 'seed_dump'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
gem 'haml'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
gem 'bcrypt-ruby'

gem 'sidekiq'
gem 'sidetiq'

gem 'spreadsheet'

gem "paperclip", :git => "git://github.com/thoughtbot/paperclip.git"

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development
 gem 'tzinfo-data'
# Use debugger
gem 'factory_girl'
group :development, :test do
  gem 'rspec-rails'
  gem 'capybara'
  gem 'faker'
  gem 'byebug'
end
