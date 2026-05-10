require 'rails_helper'

RSpec.describe 'User Authentication', type: :request do
  include Warden::Test::Helpers

  let(:team) { create(:team) }

  describe 'GET /users/sign_up' do
    it 'returns a success response' do
      get new_user_registration_path
      expect(response).to have_http_status(:ok)
    end

    it 'renders sign up form' do
      get new_user_registration_path
      expect(response.body).to include('Sign Up')
    end
  end

  describe 'POST /users (sign up)' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          user: {
            full_name: 'John Doe',
            email: 'john@example.com',
            password: 'password123',
            password_confirmation: 'password123',
            team_id: team.id
          }
        }
      end

      it 'creates a new user' do
        expect {
          post user_registration_path, params: valid_params
        }.to change(User, :count).by(1)
      end

      it 'signs in the user' do
        post user_registration_path, params: valid_params
        expect(request.env['warden'].authenticated?(:user)).to be true
      end

      it 'redirects to dashboard after sign up' do
        post user_registration_path, params: valid_params
        # FIX: Removed (user.team) because the route is singular
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context 'with invalid parameters' do
      it 'displays error messages' do
        params = { user: { email: 'invalid' } }
        post user_registration_path, params: params
        # Match whatever error text your form shows (usually 'prohibited' or 'error')
        expect(response.body).to include('error') 
      end
    end
  end

  describe 'POST /users/sign_in' do
    let(:user) { create(:user, team: team, email: 'user@example.com', password: 'password123') }

    context 'with valid credentials' do
      it 'signs in the user' do
        post user_session_path, params: {
          user: { email: user.email, password: 'password123' }
        }
        expect(request.env['warden'].authenticated?(:user)).to be true
      end

      it 'redirects to dashboard' do
        post user_session_path, params: {
          user: { email: user.email, password: 'password123' }
        }
        # FIX: Removed (user.team)
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context 'with invalid credentials' do
      it 'displays error message' do
        post user_session_path, params: {
          user: { email: user.email, password: 'wrong' }
        }
        # Ensure 'email' is lowercase to match Devise/Bootstrap output
        expect(response.body).to include('Invalid email or password')
      end
    end
  end

  describe 'DELETE /users/sign_out' do
    let(:user) { create(:user, team: team) }

    it 'signs out the user' do
      sign_in user
      delete destroy_user_session_path
      expect(request.env['warden'].authenticated?(:user)).to be false
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'Root path redirection' do
    context 'when user is signed in' do
      let(:user) { create(:user, team: team) }

      it 'redirects from home to dashboard' do
        sign_in user
        get root_path
        # FIX: Removed (user.team)
        expect(response).to redirect_to(dashboard_path)
      end
    end
  end
end