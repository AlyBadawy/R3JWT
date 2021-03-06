require "spec_helper"
ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../config/environment", __dir__)

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

require "rspec/rails"
# Add additional requires below this line. Rails is not loaded until this point!
require "database_cleaner"
require "capybara/rspec"

Dir[Rails.root.join("spec", "support", "**", "*.rb")].each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  config.include ActiveSupport::Testing::TimeHelpers

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.before(:suite) { DatabaseCleaner.clean_with(:truncation) }
  config.before(:each) { DatabaseCleaner.strategy = :transaction }
  config.before(:each, js: true) { DatabaseCleaner.strategy = :truncation }
  config.before(:each) { DatabaseCleaner.start }
  config.after(:each) { DatabaseCleaner.clean }
  config.before(:all) { DatabaseCleaner.start }
  config.after(:all) { DatabaseCleaner.clean }
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  Shoulda::Matchers.configure do |conf|
    conf.integrate do |with|
      # Choose a test framework:
      with.test_framework :rspec
      with.library :rails
    end
  end
end
