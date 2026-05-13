class TeamMailer < ApplicationMailer
  default from: 'notifications@teamstandup.com'

  def digest_email(manager, standups)
    @manager = manager
    @standups = standups
    @team = manager.team

    mail(to: @manager.email, subject: "Daily Team Summary: #{@team.name}")
  end
end