FactoryBot.define do
  factory :standup do
    # This tells FactoryBot to use your existing :user factory 
    # to create a user automatically when creating a standup.
    association :user

    worked_on_yesterday { "Completed the authentication logic and updated the README." }
    plan_for_today { "Implement the standup creation form and database constraints." }
    blockers { "Waiting for feedback on the UI layout." }
    needs_help { false }
    
    # We use Date.today as the default for tests
    created_at_date { Date.today }
  end
end