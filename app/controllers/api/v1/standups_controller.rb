module Api
  module V1
    class StandupsController < ApplicationController
      # 1. Skip the global HTML auth
      skip_before_action :authenticate_user!
      
      # 2. Use a custom "check" that works for APIs
      def today
        # This helper allows Devise to try logging in via Basic Auth for this one request
        user = authenticate_with_http_basic { |email, password|
          u = User.find_by(email: email)
          u if u&.valid_password?(password)
        }

        if user
          @standups = user.team.standups.where(created_at_date: Date.today)
          render json: @standups.as_json(
            include: { user: { only: [:full_name] } },
            only: [:id, :worked_on_yesterday, :plan_for_today, :blockers, :needs_help]
          )
        else
          render json: { error: "Invalid Credentials" }, status: :unauthorized
        end
      end
    end
  end
end