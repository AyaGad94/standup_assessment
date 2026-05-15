source "https://rubygems.org"

gem "rails", "~> 8.1.3"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "propshaft"
gem "devise"
gem "pundit"
gem "discard", "~> 1.3"
gem 'pagy', '~> 43.5'

# Hotwire & Styling
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "jbuilder"

# Rails 8 Solid Stack
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Deployment & Optimization
gem "thruster", require: false
gem "kamal", require: false
gem "bootsnap", require: false
gem "image_processing", "~> 1.2"

# Windows support
gem "tzinfo-data", platforms: %i[ windows jruby ]

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "shoulda-matchers"
end

group :development do
  gem "web-console"
  gem "letter_opener" 
  gem "brakeman", require: false
  gem "bundler-audit", require: false
  gem "rubocop-rails-omakase", require: false
end