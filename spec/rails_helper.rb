# spec/rails_helper.rb
require 'spec_helper'
ENV['VIPS_WARNING'] = '0'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'
require 'shoulda/matchers'

# Add additional requires below this line. Rails is not loaded until this point!
# Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

RSpec.configure do |config|
  # Use plural fixture_paths for Rails 7+
  config.fixture_paths = ["#{::Rails.root}/spec/fixtures"]

  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!

  # THE FIX: Correct method name for modern RSpec-Rails
  config.filter_rails_from_backtrace!

  # --- FactoryBot ---
  config.include FactoryBot::Syntax::Methods

  # --- Devise ---
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Warden::Test::Helpers

  config.after(:each) { Warden.test_reset! }

  # --- Shoulda Matchers ---
  Shoulda::Matchers.configure do |sm_config|
    sm_config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end

  # Helpers for request specs
  def sign_in(user)
    post user_session_path, params: {
      user: { email: user.email, password: 'password123' }
    }
  end
end