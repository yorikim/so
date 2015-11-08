require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :question }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
end
