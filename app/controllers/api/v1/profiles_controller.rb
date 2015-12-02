class Api::V1::ProfilesController < Api::V1::ApplicationController
  authorize_resource class: User, instance_name: :current_resource_owner

  def me
    authorize! :me, current_resource_owner
    respond_with current_resource_owner
  end

  def index
    respond_with User.where.not(id: current_resource_owner)
  end
end
