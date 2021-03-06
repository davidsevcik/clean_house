require 'rbconfig'
HOST_OS = RbConfig::CONFIG['host_os']

ruby "~> 2.6"

source 'https://rubygems.org'

gem 'rails', '~> 3.2'
gem 'thin'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# gem 'mysql2', :group => :development
gem 'pg'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  # gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platform => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
# gem 'debugger', :group => :development

# gem "rspec-rails", ">= 2.9.0.rc2", :group => [:development, :test]
# gem "factory_girl_rails", ">= 3.2.0", :group => [:development, :test]
# gem "email_spec", ">= 1.2.1", :group => :test
# gem "cucumber-rails", ">= 1.3.0", :group => :test, :require => false
# gem "capybara", ">= 1.1.2", :group => :test
# gem "database_cleaner", ">= 0.7.2", :group => :test
# gem "launchy", ">= 2.1.0", :group => :test

# case HOST_OS
#   when /darwin/i
    # gem 'rb-fsevent', :group => :development
    # gem 'growl', :group => :development
#   when /linux/i
#     gem 'libnotify', :group => :development
#     gem 'rb-inotify', :group => :development
#   when /mswin|windows/i
#     gem 'rb-fchange', :group => :development
#     gem 'win32console', :group => :development
#     gem 'rb-notifu', :group => :development
# end

group :development, :test do
  # gem "guard", ">= 0.6.2"
  # gem "guard-bundler", ">= 0.1.3"
  # gem "guard-rails", ">= 0.0.3"
  # gem "guard-livereload", ">= 0.3.0"
  # gem "guard-rspec", ">= 0.4.3"
  # gem "guard-cucumber", ">= 0.6.1"
  # gem 'pry'
  # gem 'pry-nav'
  # gem 'pry-rails'
end

gem "bootstrap-sass"
# gem "simple_form"
# gem "will_paginate", ">= 3.0.3"

gem "watu_table_builder", :require => "table_builder"
gem 'acts_as_list'
gem 'simple_form'
gem 'pony'
# gem "formtastic", "~> 2.1.1"
# gem 'activeadmin'
# gem "meta_search",    '>= 1.1.0.pre'
