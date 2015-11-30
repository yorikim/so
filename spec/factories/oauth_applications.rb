FactoryGirl.define do
  factory :oauth_application, class: Doorkeeper::Application do
    sequence(:name) { |n| "Test App ##{n}" }
    redirect_uri "urn:ietf:wg:oauth:2.0:oob"
    sequence(:uid) { |n| "3231267#{n}" }
    sequence(:secret) { |n| "909812749#{n}" }
  end
end