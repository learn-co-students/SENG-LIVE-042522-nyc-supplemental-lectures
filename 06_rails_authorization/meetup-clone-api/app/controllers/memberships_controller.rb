class MembershipsController < ApplicationController
  before_action :set_membership, only: [:destroy]
  before_action :authorize_user, only: [:destroy]

  def create
    membership = current_user.memberships.create!(membership_params)
    render json: membership, status: :created
  end

  def destroy
    @membership.destroy
  end

  private

  def membership_params
    params.permit(:group_id)
  end

  def set_membership
    @membership = Membership.find(params[:id])
  end

  def authorize_user
    if current_user.admin? || @membership.user == current_user
      return
    else
      render json: { error: "You don't have permission to perform that action" }, status: :forbidden
    end
  end
end
