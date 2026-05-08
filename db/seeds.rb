Comment.destroy_all
Standup.destroy_all
User.destroy_all
Team.destroy_all


engineering = Team.create!(name: "Engineering")

aya = User.create!(
  full_name: "Aya Gad", 
  email: "aya@example.com", 
  password: "password123", 
  team: engineering
)

rokaya = User.create!(
  full_name: "Rokaya", 
  email: "rokaya@example.com", 
  password: "password123", 
  team: engineering
)

roro = User.create!(
  full_name: "RoRo", 
  email: "roro@example.com", 
  password: "password123", 
  team: engineering
)

Standup.create!(
  user: Aya,
  worked_on_yesterday: "Setup PostgreSQL and Rails Models",
  plan_for_today: "Working on the Dashboard UI",
  blockers: "Waiting for API keys",
  needs_help: true 
)

puts "✅ Seeds created successfully!"
puts "Logged in user will be: #{aya.email}"