class DashboardsController < ApplicationController
  before_action :authenticate_user!
  def show
    @team = current_user.team 
    @pagy, @submitted_standups = pagy(@team.submitted_standups_today.includes(:user).order(created_at: :desc), limit: 5)

    @missing_members = @team.missing_members_today
    @help_needed     = @team.help_needed_blockers
    
    #  Always use the base relation for counts to ensure the progress bar is accurate
    @submitted_count = @team.submitted_standups_today.count
    @total_count     = @team.active_members.count
  end
end