FactoryBot.define do
  factory :team do
    # ===================================
    # Default Attributes
    # ===================================
    sequence(:name) { |n| "Team #{n}" }
    description { Faker::Lorem.sentence }
    # archived_at { nil }
 
    # ===================================
    # Traits for Different Scenarios
    # ===================================
    
    # Archived team (soft deleted)
    trait :archived do
      archived_at { Time.current }
    end
 
    # Active team (not archived)
    trait :active do
    #   archived_at { nil }
    end
 
    # Team with users
    trait :with_users do
      after(:create) do |team|
        create_list(:user, 3, team: team)
      end
    end
 
    # Team with users and their standups for today
    trait :with_users_and_standups do
      after(:create) do |team|
        3.times do
          user = create(:user, team: team)
          create(:standup, user: user, created_at_date: Date.today)
        end
      end
    end
 
    # Team with missing members (some users without standups)
    trait :with_missing_members do
      after(:create) do |team|
        # Create 2 users with standups
        2.times do
          user = create(:user, team: team)
          create(:standup, user: user, created_at_date: Date.today)
        end
        
        # Create 1 user without standup (missing)
        create(:user, team: team)
      end
    end
 
    # Team with blockers
    trait :with_blockers do
      after(:create) do |team|
        user = create(:user, team: team)
        create(:standup, 
          user: user, 
          created_at_date: Date.today,
          blockers: "Database is slow",
          needs_help: true
        )
      end
    end
 
    # Team with many users
    trait :with_many_users do
      after(:create) do |team|
        create_list(:user, 10, team: team)
      end
    end
 
    # Team with specific name (useful for testing)
    trait :product_team do
      name { "Product Team" }
    end
 
    trait :engineering_team do
      name { "Engineering Team" }
    end
 
    trait :design_team do
      name { "Design Team" }
    end
  end
end
 
# ===================================
# Factory Usage Examples
# ===================================
#
# Create a basic team:
#   team = create(:team)
#
# Create a team with custom name:
#   team = create(:team, name: "My Team")
#
# Create an archived team:
#   team = create(:team, :archived)
#
# Create a team with 3 users:
#   team = create(:team, :with_users)
#
# Create a team with users and standups:
#   team = create(:team, :with_users_and_standups)
#
# Create a team with missing members:
#   team = create(:team, :with_missing_members)
#   # team.missing_members_today.count == 1
#
# Create a team with blockers:
#   team = create(:team, :with_blockers)
#   # team.standups.needs_help.count == 1
#
# Combine traits:
#   team = create(:team, :product_team, :with_users)
#
# Create multiple teams:
#   teams = create_list(:team, 5)
#
# Create team without saving to database:
#   team = build(:team)