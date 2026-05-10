require 'rails_helper'

RSpec.describe "Dashboards", type: :request do
  let(:user) { create(:user) }

  describe "GET /dashboard" do
    context "when authenticated" do
      before { sign_in user }

      it "returns http success" do
        # Pass the team object so the route becomes /dashboards/4
        get dashboard_path(user.team) 
        expect(response).to have_http_status(:success)
      end
    end

    context "when not authenticated" do
      it "redirects to sign in" do
        # Even here, the helper needs a dummy ID or object to generate the URL
        get dashboard_path(id: 999) 
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end