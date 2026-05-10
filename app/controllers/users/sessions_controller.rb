class Users::SessionsController < Devise::SessionsController
  
  def destroy
    sign_out(current_user)
    redirect_to root_path, notice: "You have been signed out successfully."
  end
 
  protected
 
  
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password, :remember_me])
  end
 
  def after_sign_in_path_for(resource)
    dashboard_path
  end
 
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end