require 'rails_helper'

RSpec.describe Standup, type: :model do
  let(:user) { create(:user) }

  describe "Associations" do
    it { should belong_to(:user) }
  end

  describe "Validations" do
    it "is valid with valid attributes" do
      standup = build(:standup, user: user)
      expect(standup).to be_valid
    end

    it "is invalid without worked_on_yesterday" do
      standup = build(:standup, worked_on_yesterday: nil)
      expect(standup).not_to be_valid
    end

    it "is invalid without plan_for_today" do
      standup = build(:standup, plan_for_today: nil)
      expect(standup).not_to be_valid
    end

    describe "Daily Uniqueness" do
      it "does not allow a user to create two standups on the same day" do
        # Create the first one
        create(:standup, user: user, created_at_date: Date.today)
        
        # Try to build a second one for the same day
        duplicate = build(:standup, user: user, created_at_date: Date.today)
        
        expect(duplicate).not_to be_valid
        expect(duplicate.errors[:user_id]).to include("has already submitted a standup for today")
      end

      it "allows a user to create standups on different days" do
        create(:standup, user: user, created_at_date: Date.yesterday)
        next_day = build(:standup, user: user, created_at_date: Date.today)
        
        expect(next_day).to be_valid
      end
    end
  end

  describe "Scopes" do
    it "returns only today's standups for the .today scope" do
      today_standup = create(:standup, created_at_date: Date.today)
      yesterday_standup = create(:standup, created_at_date: Date.yesterday)
      
      expect(Standup.today).to include(today_standup)
      expect(Standup.today).not_to include(yesterday_standup)
    end

    it "returns only standups needing help for the .needs_help scope" do
      helping_standup = create(:standup, needs_help: true)
      fine_standup = create(:standup, needs_help: false)
      
      expect(Standup.needs_help).to include(helping_standup)
      expect(Standup.needs_help).not_to include(fine_standup)
    end
  end
end