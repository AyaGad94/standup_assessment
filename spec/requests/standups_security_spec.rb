require 'rails_helper'

RSpec.describe "Standups Security & Workflow", type: :request do
  # Setup two different teams and users
  let(:team_a) { create(:team, name: "Team A") }
  let(:team_b) { create(:team, name: "Team B") }
  let(:user_a) { create(:user, team: team_a) }
  let(:user_b) { create(:user, team: team_b) }

  before do
    # Log in User A using Devise test helpers
    sign_in user_a
  end

  describe "Happy Path (Creation)" do
    it "allows user to create a standup and redirects to dashboard" do
      post standups_path, params: { 
        standup: { 
          worked_on_yesterday: "Coding", 
          plan_for_today: "Testing", 
          needs_help: false 
        } 
      }
      
      expect(response).to redirect_to(dashboard_path)
      follow_redirect!
      expect(response.body).to include("Standup was successfully created.")
    end
  end

  describe "Team Data Isolation" do
    it "prevents user_a from viewing a standup from team_b" do
      # Create a standup belonging to a user on Team B
      standup_b = create(:standup, user: user_b)

      # User A tries to access it via URL
      get standup_path(standup_b)

      # Should kick them back to dashboard with an alert
      expect(response).to redirect_to(dashboard_path)
      expect(flash[:alert]).to eq("You are not authorized to view that standup.")
    end
  end
end