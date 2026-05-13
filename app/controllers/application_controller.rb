
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, unless: -> { request.format.json? }
  include Pagy::Backend
  include Pundit::Authorization
  before_action :authenticate_user!, unless: -> { request.format.json? }
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  def after_sign_in_path_for(resource)
    dashboard_path 
  end
 
  private
 
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name, :team_id, :role, :new_team_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:full_name, :role])
  end
 
  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end
end