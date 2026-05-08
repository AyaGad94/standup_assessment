class DashboardsController < ApplicationController
  
  def show
    @user = User.first 
    @team = @user.team 
    @submitted_standups = @team.standups.today
    @missing_members = @team.missing_members_today
    @help_needed = @team.standups.needs_help
  end
end