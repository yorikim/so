require 'rails_helper'
require "active_attr/rspec"

RSpec.describe SearchQuery do
  it { should have_attribute(:q) }
  it { should have_attribute(:index_type) }

  it { should validate_inclusion_of(:index_type).in_array([nil, *%w(question answer comment)]) }
end