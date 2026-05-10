class StandupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_standup, only: [:edit, :update, :destroy]
  before_action :authorize_standup_owner!, only: [:edit, :update, :destroy]

  def new
    if current_user.standups.today.exists?
      redirect_to dashboard_path, alert: "You have already submitted a standup for today."
    else
      @standup = current_user.standups.new
    end
  end

  def create
    @standup = current_user.standups.new(standup_params)
    
    if @standup.save
      redirect_to dashboard_path, notice: "Standup was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @standup.update(standup_params)
      redirect_to dashboard_path, notice: "Standup was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @standup.destroy
    redirect_to dashboard_path, notice: "Standup was deleted."
  end

  private

  def set_standup
    @standup = Standup.find(params[:id])
  end

  def authorize_standup_owner!

    unless @standup.user == current_user && @standup.created_at_date == Date.today
      redirect_to dashboard_path, alert: "You are not authorized to edit this standup (Same-day edit window only)."
    end
  end

  def standup_params
    params.require(:standup).permit(:worked_on_yesterday, :plan_for_today, :blockers, :needs_help)
  end
end