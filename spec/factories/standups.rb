FactoryBot.define do
  factory :standup do
    association :user
    worked_on_yesterday { "Completed the authentication logic." }
    plan_for_today { "Implement the standup creation form." }
    blockers { "Waiting for feedback." }
    needs_help { false }
    
    # Use a sequence to ensure uniqueness in tests
    sequence(:created_at_date) { |n| Date.today - n.days }
  end
end