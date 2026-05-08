class Standup < ApplicationRecord
  belongs_to :user
  has_one :team, through: :user
  has_many :comments, as: :commentable, dependent: :destroy 

  validates :worked_on_yesterday, :plan_for_today, presence: true
  
  
  validates :user_id, uniqueness: { 
    scope: :created_at_date, 
    message: "has already submitted a standup for today" 
  }

  
  scope :today, -> { where(created_at_date: Date.today) }
  scope :needs_help, -> { where(needs_help: true) }
  before_validation :set_created_at_date, on: :create

  private

  def set_created_at_date
    self.created_at_date ||= Date.today
  end
end