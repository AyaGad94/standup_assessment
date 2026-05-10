class Team < ApplicationRecord
  # Associations
  has_many :users, dependent: :destroy
  has_many :standups, through: :users
 
  # Validations
  validates :name, presence: true, uniqueness: true, length: { minimum: 2, maximum: 100 }
 
  # Scopes
  scope :active, -> { where(archived_at: nil) }
 
  # Instance Methods
  def active_members
    users.where(archived_at: nil)
  end
 
  def archived?
    archived_at.present?
  end
 
  def missing_members_today
    submitted_user_ids = standups.where(created_at_date: Date.today).pluck(:user_id).uniq
    
    if submitted_user_ids.any?
      active_members.where.not(id: submitted_user_ids)
    else
      active_members
    end
  end
 
  def submitted_standups_today
    standups.where(created_at_date: Date.today)
  end
 
  def help_needed_blockers
    standups.where(created_at_date: Date.today, needs_help: true)
  end
end