require "bundler/setup"
::Bundler.require(:default, :test)

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

require "shoulda-matchers"
::Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec

    # Choose one or more libraries:
    with.library :active_record
    with.library :active_model
    with.library :action_controller
    # Or, choose the following (which implies all of the above):
    #with.library :rails
  end
end

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include Devise::TestHelpers, type: :controller

  config.extend ControllerMacros, type: :controller
  config.include FeatureMacros, type: :feature

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.backtrace_exclusion_patterns = [
      /\/lib\d*\/ruby\//,
      /bin\//,
      /gems/,
      /spec\/spec_helper\.rb/,
      /lib\/rspec\/(core|expectations|matchers|mocks)/
  ]

  config.after(:all) do
    if Rails.env.test?
      FileUtils.rm_rf(Dir["#{Rails.root}/public/question/[^.]*"])
      FileUtils.rm_rf(Dir["#{Rails.root}/public/answer/[^.]*"])
    end
  end
end