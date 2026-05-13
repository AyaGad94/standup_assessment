📋 Team Standup & Blockers
🚀 Overview
A Rails 8.1.3 web application where team members log daily standup updates. The app features a role-based Team Dashboard that adapts based on whether a user is a Member or a Manager, providing high-level insights, automated email reporting, and real-time blocker tracking.

🛠 Tech Stack
Framework: Ruby on Rails (8.1.3)

Database: PostgreSQL 15

Authentication: Devise (Extended with Roles)

Background Jobs: Solid Queue (Rails 8 Default)

Soft Delete: Discard Gem

Pagination: Pagy

Email Handling: Action Mailer + Letter Opener (Dev)

Styling: Tailwind CSS + Bootstrap Nav Components

Frontend: Hotwire (Turbo Drive + Streams)

Ops: Docker & Docker Compose

🏗 Architecture Decisions
🎭 Role-Based Access Control (RBAC)
I implemented an Enum-based role system (member and manager) within the User model.

Members: Focus on their own team's standups and blockers.

Managers: Granted an "Insights" view on the dashboard to track team participation and receive automated email summaries.

♻️ Data Integrity & Auditing (Soft Delete)
To satisfy the requirement for auditing and non-destructive deletions, I implemented Soft Deletes using the discard gem.

Logic: When a user deletes a standup, it is marked with a discarded_at timestamp rather than being removed from the database.

Database Strategy: I utilized a Partial Unique Index in PostgreSQL (where: "discarded_at IS NULL") to allow users to delete a mistake and immediately post a new standup for the same day without violating uniqueness constraints.

🚀 Performance & Scalability (Pagination)
To handle high-volume data without compromising page load speeds, I integrated Pagy.

Efficiency: Unlike heavier gems, Pagy uses significantly less memory and performs faster count queries.

UX: Implemented a limit: 5 (configurable) on the main dashboard with Bootstrap-styled navigation and pagy_info to provide users with clear context on the total records available.

📧 Background Processing: Solid Queue
To handle the Daily Digest Email, I utilized Rails 8's Solid Queue.

Job Pattern: The SendDailyDigestJob iterates through teams and delivers summaries only to users with the manager role.

Adapter: Configured to :inline in development for immediate feedback, and :solid_queue for production-ready async delivery.

⚙️ Core Logic & Constraints
🗓️ Daily Standup Limit
Enforced via Rails validation uniqueness: { scope: :created_at_date, conditions: -> { kept } } and a database-level partial unique index to ensure data integrity.

📊 Dashboard Intelligence
The dashboard logic is role-aware:

Universal: Everyone sees today's submissions and the "Help Needed" (blocker) section.

Manager Exclusive: Automatically calculates "Missing Updates" by comparing the team roster against today's submissions and displays them in a dedicated sidebar.

📩 Automated Reporting
Managers receive a daily HTML email containing:

A list of all team standups for the day.

Highlighted Blocker text in red for immediate review.

Direct links to the dashboard for discussion.

🐳 Docker & Containerization
The app is fully containerized for both development and production.

Orchestration: docker-compose.yml manages the Rails app, Solid Queue workers, and the PostgreSQL 15 database.

Quick Start with Docker
Build and Lift:
docker-compose up --build

Setup Database:
docker-compose exec web bin/rails db:prepare db:seed
Access: Open http://localhost:3000

💻 Manual Testing (Development)
Testing the Email System
Since the app is in development mode, emails are caught by the letter_opener gem.

Ensure you have at least one user with the Manager role.

Run the digest job manually in the console:

rails c
SendDailyDigestJob.perform_now
The email will automatically open in your browser or can be found in tmp/letter_opener.

Manual Setup:

bundle install
rails db:prepare
rails db:migrate
rails s