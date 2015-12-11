require 'rails_helper'

RSpec.describe SphinxController, type: :controller do
  include Devise::TestHelpers

  describe "GET #search" do
    [nil, 'question', 'answer', 'comment', 'user'].each do |index_type|
      it "returns matched questions" do
        index = index_type ? Kernel.const_get(index_type.capitalize) : ThinkingSphinx
        expect(index).to receive(:search).with(anything)
        get :search, search_query: {q: 'test', index_type: index_type}
      end
    end
  end
end
