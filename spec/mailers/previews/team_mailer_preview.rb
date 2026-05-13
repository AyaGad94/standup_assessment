class TeamMailerPreview < ActionMailer::Preview

  def digest_email
    # Create or find a dummy manager and some dummy standups for the preview
    manager = User.find_by(role: :manager) || User.first
    standups = Standup.where(created_at_date: Date.today).limit(3)

    # Pass these dummy objects to the mailer method
    TeamMailer.digest_email(manager, standups)
  end

end