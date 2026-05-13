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
    # We use .kept here so that people who "deleted" their standup 
    # appear back in the missing list
    submitted_user_ids = standups.today.kept.pluck(:user_id).uniq
    
    if submitted_user_ids.any?
      active_members.where.not(id: submitted_user_ids)
    else
      active_members
    end
  end
 
  
  def submitted_standups_today
    # Added .kept to filter out soft-deleted standups
    standups.today.kept
  end
 
  
  def help_needed_blockers
    # Added .kept to filter out soft-deleted blockers
    standups.today.kept.needs_help
  end
end