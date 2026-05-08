class User < ApplicationRecord
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :team, optional: true 
  has_many :standups, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :full_name, presence: true

end