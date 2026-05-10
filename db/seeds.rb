
puts "🗑️  Clearing existing data..."
Comment.destroy_all
Standup.destroy_all
User.destroy_all
Team.destroy_all
 
puts "📦 Creating seed data for ST-02...\n"
 
# Create teams
puts "👥 Creating teams..."
team_1 = Team.create!(
  name: "Product Team",
  description: "Main product development team"
)
puts "  ✅ Created team: #{team_1.name}"
 
team_2 = Team.create!(
  name: "Engineering Team",
  description: "Platform engineering team"
)
puts "  ✅ Created team: #{team_2.name}"
 
team_3 = Team.create!(
  name: "Design Team",
  description: "User experience and design team"
)
puts "  ✅ Created team: #{team_3.name}"
 
# Create users for Team 1 (Product Team)
puts "\n👤 Creating users for Product Team..."
user_alice = User.create!(
  full_name: "Alice Johnson",
  email: "alice@example.com",
  password: "password123",
  password_confirmation: "password123",
  team: team_1
)
puts "  ✅ Created user: #{user_alice.full_name} (#{user_alice.email})"
 
user_bob = User.create!(
  full_name: "Bob Smith",
  email: "bob@example.com",
  password: "password123",
  password_confirmation: "password123",
  team: team_1
)
puts "  ✅ Created user: #{user_bob.full_name} (#{user_bob.email})"
 
user_charlie = User.create!(
  full_name: "Charlie Brown",
  email: "charlie@example.com",
  password: "password123",
  password_confirmation: "password123",
  team: team_1
)
puts "  ✅ Created user: #{user_charlie.full_name} (#{user_charlie.email})"
 
# Create users for Team 2 (Engineering Team)
puts "\n👤 Creating users for Engineering Team..."
user_diana = User.create!(
  full_name: "Diana Prince",
  email: "diana@example.com",
  password: "password123",
  password_confirmation: "password123",
  team: team_2
)
puts "  ✅ Created user: #{user_diana.full_name} (#{user_diana.email})"
 
user_eve = User.create!(
  full_name: "Eve Williams",
  email: "eve@example.com",
  password: "password123",
  password_confirmation: "password123",
  team: team_2
)
puts "  ✅ Created user: #{user_eve.full_name} (#{user_eve.email})"
 
# Create users for Team 3 (Design Team)
puts "\n👤 Creating users for Design Team..."
user_frank = User.create!(
  full_name: "Frank Miller",
  email: "frank@example.com",
  password: "password123",
  password_confirmation: "password123",
  team: team_3
)
puts "  ✅ Created user: #{user_frank.full_name} (#{user_frank.email})"
 
# Create standups (simulating real usage)
puts "\n📝 Creating standups for ST-01 verification..."
 
# Alice's standup today
standup_alice = Standup.create!(
  user: user_alice,
  worked_on_yesterday: "Completed user authentication feature and wrote unit tests",
  plan_for_today: "Deploy auth feature to staging and get QA approval",
  blockers: nil,
  needs_help: false,
  created_at_date: Date.today
)
puts "  ✅ Created standup for #{user_alice.full_name}"
 
# Bob's standup today with blockers needing help
standup_bob = Standup.create!(
  user: user_bob,
  worked_on_yesterday: "Fixed database migration issues from the refactor",
  plan_for_today: "Optimize query performance for reports",
  blockers: "Database queries are running slow on large datasets, need help from Diana on optimization techniques",
  needs_help: true,
  created_at_date: Date.today
)
puts "  ✅ Created standup for #{user_bob.full_name} (with blockers)"
 
# Charlie has no standup today (for missing members test)
puts "  ℹ️  #{user_charlie.full_name} has no standup today (for missing members verification)"
 
# Diana's standup
standup_diana = Standup.create!(
  user: user_diana,
  worked_on_yesterday: "Reviewed and merged 3 pull requests",
  plan_for_today: "Implement caching layer for API responses",
  blockers: nil,
  needs_help: false,
  created_at_date: Date.today
)
puts "  ✅ Created standup for #{user_diana.full_name}"
 
# Eve has no standup today
puts "  ℹ️  #{user_eve.full_name} has no standup today (for missing members verification)"
 
# Frank's standup
standup_frank = Standup.create!(
  user: user_frank,
  worked_on_yesterday: "Completed mockups for new dashboard",
  plan_for_today: "Present designs to stakeholders and collect feedback",
  blockers: "Waiting on product requirements clarification",
  needs_help: true,
  created_at_date: Date.today
)
puts "  ✅ Created standup for #{user_frank.full_name} (with blockers)"
 
# Create comments on blockers
puts "\n💬 Creating comments on blockers..."
 
comment_1 = Comment.create!(
  user: user_diana,
  commentable: standup_bob,
  body: "I can help with query optimization! Let's sync up this afternoon to discuss indexing strategies."
)
puts "  ✅ Comment from #{user_diana.full_name} on #{user_bob.full_name}'s blocker"
 
comment_2 = Comment.create!(
  user: user_charlie,
  commentable: standup_frank,
  body: "The product team is finalizing requirements today. I'll ping you when they're ready."
)
puts "  ✅ Comment from #{user_charlie.full_name} on #{user_frank.full_name}'s blocker"
 
puts "\n" + "="*60
puts "✨ Seed data created successfully!"
puts "="*60
puts "\n📊 Summary:"
puts "  Teams created: #{Team.count}"
puts "  Users created: #{User.count}"
puts "  Standups created: #{Standup.count}"
puts "  Comments created: #{Comment.count}"
puts "\n🔑 Test Credentials:"
puts "  Email: alice@example.com | Password: password123 | Team: Product Team"
puts "  Email: bob@example.com | Password: password123 | Team: Product Team"
puts "  Email: diana@example.com | Password: password123 | Team: Engineering Team"
puts "  Email: frank@example.com | Password: password123 | Team: Design Team"
puts "\n📋 Verification Tests:"
puts "  ✓ Team 1 (Product) missing members: #{team_1.missing_members_today.map(&:full_name).join(', ')}"
puts "  ✓ Team 2 (Engineering) missing members: #{team_2.missing_members_today.map(&:full_name).join(', ')}"
puts "  ✓ Blockers needing help: #{Standup.needs_help.count}"
puts "="*60