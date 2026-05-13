class SendDailyDigestJob < ApplicationJob
  queue_as :default

  def perform
  Team.find_each do |team|
    # .where(role: :manager) returns a collection (all managers)
    managers = team.users.where(role: :manager) 
    standups = team.standups.where(created_at_date: Date.today)

    if standups.any?
      managers.each do |manager|
        TeamMailer.digest_email(manager, standups).deliver_later
      end
    end
  end
end
end