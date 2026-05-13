require "rails_helper"

RSpec.describe TeamMailer, type: :mailer do
  describe "digest_email" do
    # 1. Define the data the mailer needs
    let(:team)    { create(:team, name: "Design Team") }
    let(:manager) { create(:user, role: :manager, team: team, email: "manager@example.com") }
  
    # 2. Pass the defined data into the mailer
    let(:mail) { TeamMailer.digest_email(manager, standups) }

    it "renders the headers" do
    expect(mail.subject).to eq("Daily Team Summary: Design Team")
    expect(mail.to).to eq(["manager@example.com"])
    expect(mail.from).to eq(["notifications@teamstandup.com"]) 
    end

   let(:standups) do
   [
    create(:standup, user: manager, created_at_date: Date.today),
    create(:standup, user: manager, created_at_date: 1.day.ago),
    create(:standup, user: manager, created_at_date: 2.days.ago)
   ]
   end
    
    it "renders the body" do
   expect(mail.body.encoded).to match(manager.full_name)
   expect(mail.body.encoded).to match("Daily Standup Summary")
  end

  end
end