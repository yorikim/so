class Api::V1::ApplicationController < ApplicationController
  before_action :doorkeeper_authorize!
  authorize_resource class: false

  respond_to :json


  protected

  def current_ability
    @current_ability ||= Ability.new(current_resource_owner)
  end

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end