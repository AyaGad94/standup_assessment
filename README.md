# 📋 Team Standup & Blockers

## 🚀 Overview
A Rails 7+ web application where team members log daily standup updates (yesterday, today, and blockers). The app features a centralized **Team Dashboard** to track progress, identify missing updates, and highlight blockers that need immediate attention.

## 🛠 Tech Stack
* **Framework:** Ruby on Rails (7.x)
* **Database:** PostgreSQL
* **Authentication:** Devise
* **Styling:** Bootstrap 5
* **Frontend:** Hotwire (Turbo + Stimulus)
* **Testing:** RSpec (Model and Request specs)

---

## 🏗 Architecture Decisions

### 🔐 Authentication: Devise
I implemented **Devise** to handle user sessions. This provides a secure, industry-standard foundation for sign-up and sign-in, ensuring that only authenticated users can access the team data.

### 👥 Team Membership: One-to-Many
To meet the requirement for strict data isolation, I modeled the relationship so that **a user belongs to one team**. This ensures a simple, secure boundary where users are locked into their specific team's context.

### 🛡️ Authorization: Secure Singular Routing
A key architectural choice was converting the dashboard from a plural resource to a **Singular Resource** (`resource :dashboard`).
* **Security:** This prevents **IDOR** (Insecure Direct Object Reference) vulnerabilities. Since the URL is simply `/dashboard` (with no ID), users cannot "guess" or "hop" to other teams' dashboards by changing a number in the URL.
* **Implementation:** The `DashboardsController` fetches data based strictly on the `current_user.team` session, making the application more secure by design.

---

## ⚙️ Core Logic & Constraints
* **🗓️ Daily Standup Limit:** The system enforces a "one standup per user per day" rule. This is handled via a Rails validation `uniqueness: { scope: :created_at_date }` and backed by a database-level unique index to prevent duplicate entries.
* **📊 Dashboard Intelligence:** The dashboard automatically calculates **"Missing Updates"** by comparing the team's total roster against the standups submitted for the current calendar date.
* **🆘 Blocker Visibility:** Any standup marked with `needs_help: true` is automatically promoted to the **"Help Needed"** section of the dashboard for immediate visibility.

---

## 💻 Setup & Installation

### Prerequisites
* **Ruby version:** 3.3.x
* **PostgreSQL**

### Steps
1.  **Clone and Install:**
    ```bash
    bundle install
    ```
2.  **Database Setup:**
    ```bash
    rails db:prepare
    rails db:seed
    ```
3.  **Run the Server:**
    ```bash
    rails s
    ```
4.  **Run Tests:**
    ```bash
    bundle exec rspec
    ```

---