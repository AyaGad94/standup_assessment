# spec/factories/user_factory.rb
# Factory definition for User model
# Used in tests to quickly create test users with valid attributes
 
FactoryBot.define do
  factory :user do
    # ===================================
    # Default Attributes
    # ===================================
    sequence(:full_name) { |n| Faker::Name.unique.name }
    sequence(:email) { |n| Faker::Internet.unique.email }
    password { 'password123' }
    password_confirmation { 'password123' }
    
    
    team 
    
    # Not archived by default
    archived_at { nil }
 
    # ===================================
    # Traits for Different Scenarios
    # ===================================
    
    # User with specific team
    trait :with_team do
      association :team
    end
 
    # Archived user (soft deleted)
    trait :archived do
      archived_at { Time.current }
    end
 
    # Active user (not archived)
    trait :active do
      archived_at { nil }
    end
 
    # User with standups
    trait :with_standups do
      after(:create) do |user|
        create_list(:standup, 3, user: user)
      end
    end
 
    # User with standup submitted today
    trait :with_today_standup do
      after(:create) do |user|
        create(:standup, 
          user: user, 
          created_at_date: Date.today
        )
      end
    end
 
    # User with blocker needing help
    trait :with_blocker do
      after(:create) do |user|
        create(:standup, 
          user: user,
          created_at_date: Date.today,
          blockers: "Database connection timeout",
          needs_help: true
        )
      end
    end
 
    # User with comments
    trait :with_comments do
      after(:create) do |user|
        standup = create(:standup, user: user, created_at_date: Date.today)
        create_list(:comment, 3, user: user, commentable: standup)
      end
    end
 
    # User with specific full name
    trait :named_alice do
      full_name { "Alice Johnson" }
    end
 
    trait :named_bob do
      full_name { "Bob Smith" }
    end
 
    trait :named_charlie do
      full_name { "Charlie Brown" }
    end
 
    # User with specific email
    trait :with_custom_email do
      sequence(:email) { |n| "user#{n}@example.com" }
    end
 
    # User from specific team
    trait :from_product_team do
      team { association :team, :product_team }
    end
 
    trait :from_engineering_team do
      team { association :team, :engineering_team }
    end
 
    trait :from_design_team do
      team { association :team, :design_team }
    end
 
    # User with weak password (for testing validation failures)
    trait :weak_password do
      password { '123' }
      password_confirmation { '123' }
    end
 
    # User without password confirmation (for testing validation failures)
    trait :password_mismatch do
      password { 'password123' }
      password_confirmation { 'different456' }
    end
 
    # User without email (for testing validation failures)
    trait :without_email do
      email { '' }
    end
 
    # User without full name (for testing validation failures)
    trait :without_full_name do
      full_name { '' }
    end
  end
end
 
# ===================================
# Factory Usage Examples
# ===================================
#
# Create a basic user:
#   user = create(:user)
#
# Create a user with custom attributes:
#   user = create(:user, full_name: "John Doe", email: "john@example.com")
#
# Create multiple users:
#   users = create_list(:user, 5)
#
# Create an archived user:
#   user = create(:user, :archived)
#
# Create user with standups:
#   user = create(:user, :with_standups)
#
# Create user with today's standup:
#   user = create(:user, :with_today_standup)
#
# Create user with blocker:
#   user = create(:user, :with_blocker)
#   # user.standups.first.blockers == "Database connection timeout"
#
# Create user with comments:
#   user = create(:user, :with_comments)
#   # user.comments.count == 3
#
# Create user from specific team:
#   user = create(:user, :from_product_team)
#
# Create Alice:
#   alice = create(:user, :named_alice)
#
# Create bob from engineering team:
#   bob = create(:user, :named_bob, :from_engineering_team)
#
# Create user without saving:
#   user = build(:user)
#
# Create user with validation errors (for testing):
#   user = create(:user, :weak_password)
#   user.valid? # => false
#
# Create invalid user (without saving):
#   invalid_user = build(:user, :without_email)
#
# Access user attributes:
#   user = create(:user)
#   user.email
#   user.full_name
#   user.team
#   user.standups
#
# Sign in helper (use in request specs):
#   user = create(:user)
#   post user_session_path, params: {
#     user: { email: user.email, password: 'password123' }
#   }
 