# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Add additional requires below this line. Rails is not loaded until this point!

require 'capybara/rails'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
 Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    DatabaseCleaner.clean_with :truncation
    DatabaseCleaner.clean_with :transaction
  end

  config.after(:each) do
    ActionMailer::Base.deliveries.clear
  end

  config.around(:each, type: :feature, js: true) do |ex|
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
    self.use_transactional_fixtures = false
    ex.run
    self.use_transactional_fixtures = true
    DatabaseCleaner.clean
  end

  #config.treat_symbols_as_metadata_keys_with_true_values = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
  #config.infer_spec_type_from_file_location!
end
