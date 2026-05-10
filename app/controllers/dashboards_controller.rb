class DashboardsController < ApplicationController
  def show

    @team = current_user.team 
    @submitted_standups = @team.submitted_standups_today
    @missing_members    = @team.missing_members_today
    @help_needed        = @team.help_needed_blockers
  end
end