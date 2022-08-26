class ApplicationController < ActionController::API
  include ActionController::Cookies
  rescue_from ActiveRecord::RecordInvalid, with: :render_validation_errors
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  before_action :authenticate_user
  
  private

  # mocked for now to return the first user
  # later on this will return the user that's currently logged in
  # (after we know how to do authentication)
  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def authenticate_user
    render json: { error: "You must be logged in to do that" }, status: :unauthorized unless current_user
  end

  def render_validation_errors(e)
    render json: { error: e.record.errors.full_messages.join(", ") }, status: :unprocessable_entity
  end
  
  def render_not_found(e)
    render json: { error: e.message }, status: :not_found
  end
end
