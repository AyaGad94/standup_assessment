require 'rails_helper'
 
RSpec.describe User, type: :model do
  describe 'validations' do
    let(:team) { create(:team) }
    subject { build(:user, team: team) }
 
    it { should validate_presence_of(:full_name) }
    it { should validate_length_of(:full_name).is_at_least(2).is_at_most(100) }
    
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    
    it { should validate_presence_of(:team_id) }
 
    it 'validates email format' do
      user = build(:user, team: team, email: 'invalid-email')
      expect(user.valid?).to be_falsey
      expect(user.errors[:email]).to be_present
    end
  end
 
  describe 'associations' do
    it { should belong_to(:team) }
    it { should have_many(:standups).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
  end
 
  describe 'Devise modules' do
    let(:user) { build(:user) }
 
    it 'includes database_authenticatable' do
      expect(user).to respond_to(:valid_password?)
    end
 
    it 'includes registerable' do
      expect(User).to respond_to(:new)
    end
 
    it 'includes recoverable' do
      expect(user).to respond_to(:reset_password_token)
    end
 
    it 'includes rememberable' do
      # expect(user).to respond_to(:remember_token)
      expect(user).to respond_to(:remember_me!)
    end
 
    it 'includes validatable' do
      expect(user).to respond_to(:email_changed?)
    end
  end
 
  describe '#full_name_with_email' do
    let(:user) { create(:user) }
 
    it 'returns full name with email' do
      expect(user.full_name_with_email).to eq("#{user.full_name} (#{user.email})")
    end
  end
 
  describe '#archived?' do
    let(:user) { create(:user) }
 
    it 'returns false when archived_at is nil' do
      expect(user.archived?).to be_falsey
    end
 
    it 'returns true when archived_at is set' do
      user.update(archived_at: Time.current)
      expect(user.archived?).to be_truthy
    end
  end
 
  describe '.active scope' do
    let(:team) { create(:team) }
    let!(:active_user) { create(:user, team: team) }
    let!(:archived_user) { create(:user, team: team, archived_at: Time.current) }
 
    it 'returns only active users' do
      expect(User.active).to include(active_user)
      expect(User.active).not_to include(archived_user)
    end
  end
 
  describe 'password validations' do
    let(:team) { create(:team) }
 
    it 'requires password on creation' do
      user = User.new(full_name: 'John Doe', email: 'john@example.com', team: team, password: '')
      expect(user.valid?).to be_falsey
      expect(user.errors[:password]).to be_present
    end
 
    it 'requires password confirmation if password_confirmation attribute exists' do
      user = User.new(
        full_name: 'John Doe',
        email: 'john@example.com',
        team: team,
        password: 'password123',
        password_confirmation: 'different'
      )
      expect(user.valid?).to be_falsey
      expect(user.errors[:password_confirmation]).to be_present
    end
 
    it 'allows minimum 6 character password' do
      user = build(:user, team: team, password: '123456', password_confirmation: '123456')
      expect(user.valid?).to be_truthy
    end
  end
end