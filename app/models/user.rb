class User < ApplicationRecord
  attr_accessor :new_team_name
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :team
  has_many :standups, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :full_name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :team_id, presence: true
 scope :active, -> { where(archived_at: nil) }
 
   
  def active_for_authentication?
     super && !archived?
   end
 
   def archived?
     archived_at.present?
   end
 
  def full_name_with_email
    "#{full_name} (#{email})"
  end
 
  
  def team_attributes=(attributes)
    if attributes[:id].present?
      self.team_id = attributes[:id]
    elsif attributes[:name].present?
      team = Team.create(name: attributes[:name])
      self.team_id = team.id
    end
  end

end