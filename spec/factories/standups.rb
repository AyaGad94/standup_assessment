FactoryBot.define do
  factory :standup do
    user { nil }
    worked_on_yesterday { "MyText" }
    plan_for_today { "MyText" }
    blockers { "MyText" }
    needs_help { false }
    created_at_date { "2026-05-08" }
  end
end
