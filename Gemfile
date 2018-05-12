source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'rails', '~> 5.2.0'
gem 'unicorn'
gem 'config'
gem 'dotenv-rails', groups: [:development, :test]
gem 'bootstrap-sass', '~> 3.3.7'
gem 'sass-rails', '~> 5.0'
gem 'jquery-rails'
gem 'chartjs-ror'
gem 'uglifier', '>= 1.3.0'

gem 'dalli', group: :production
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'redis', '~> 4.0'

gem 'mini_magick', '~> 4.8'

gem 'bootsnap', '>= 1.1.0', require: false
gem 'rails-assets-slimScroll', source: 'https://rails-assets.org'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper'
end

