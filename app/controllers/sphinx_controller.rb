class SphinxController < ApplicationController
  respond_to :html, :json

  before_action :load_search_query

  def search
    authorize! :read, sphinx_index
    respond_with(@result = sphinx_index.search(@search_query.q))
  end

  private

  def load_search_query
    @search_query = SearchQuery.new(search_query_params)
  end

  def sphinx_index
    @sphinx_index ||= if SearchQuery::INDECIES.include?(@search_query.index_type)
                        Kernel.const_get(@search_query.index_type.capitalize)
                      else
                        ThinkingSphinx
                      end
  end

  def search_query_params
    params.require(:search_query).permit(:q, :index_type)
  end
end
