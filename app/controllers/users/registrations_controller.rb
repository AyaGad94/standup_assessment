class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]

  def new
    @teams = Team.all
    super
  end

  def create
    # 1. If a new team name was provided, create the team first
    if params[:user][:new_team_name].present?
      team = Team.create(name: params[:user][:new_team_name])
      params[:user][:team_id] = team.id
    end
    super
  end


  def build_resource(hash = {})
    super
    @teams = Team.all
  end

  protected
  def after_sign_up_path_for(resource)
    dashboard_path
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name, :team_id, :new_team_name])
  end
end