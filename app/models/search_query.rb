class SearchQuery
  include ActiveAttr::Model

  INDECIES = %w(question answer comment user)

  attribute :q
  attribute :index_type

  validates :index_type, inclusion: {in: [nil, *INDECIES]}
end