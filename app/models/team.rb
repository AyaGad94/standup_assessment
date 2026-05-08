class Team < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :standups, through: :users

  validates :name, presence: true, uniqueness: true

  def missing_members_today
    
    submitted_user_ids = standups.where(created_at_date: Date.today).pluck(:user_id)
    if submitted_user_ids.any?
      users.where.not(id: submitted_user_ids)
    else
      users 
    end
  end
end