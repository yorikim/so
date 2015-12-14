require_relative '../rails_helper'
require 'capybara/email/rspec'
require 'capybara/poltergeist'


RSpec.configure do |config|
  config.include SphinxHelpers, type: :feature

  config.before(:suite) do
    ThinkingSphinx::Test.init
    ThinkingSphinx::Test.start_with_autostop
  end

  Capybara.javascript_driver = :poltergeist

  config.include FeatureMacros, type: :feature

  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

# Capybara::Webkit.configure do |config|
#   config.allow_unknown_urls
# end