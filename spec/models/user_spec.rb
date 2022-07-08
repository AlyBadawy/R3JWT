require "rails_helper"

RSpec.describe User, type: :model do
  it "is valid with valid attributes" do
    user1 = create(:user)
    expect(user1).to be_valid
  end

  it "is not valid without a password" do
    user2 = build(:user, password: nil)
    expect(user2).not_to be_valid
  end

  describe "validations" do
    subject { build(:user) }

    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_uniqueness_of(:username).case_insensitive }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_length_of(:username).is_at_least(3) }
    it { is_expected.to validate_length_of(:username).is_at_most(15) }
  end

  # describe "associations" do
  #   it { is_expected.to have_many(:sessions) }
  # end

  describe "secure password" do
    before do
      @user = build(:user)
    end

    describe "when password doesn't match confirmation" do
      before { @user.password_confirmation = "mismatch" }

      it { is_expected.not_to be_valid }
    end

    describe "with a password that's too short" do
      before { @user.password = @user.password_confirmation = "a" * 5 }

      it { is_expected.to be_invalid }
    end
  end

  describe "return value of authenticate method" do
    before do
      @user = build(:user)
      @user.save
    end

    let(:found_user) { described_class.find_by(email: @user.email) }

    describe "with valid password" do
      it { expect(found_user.authenticate(@user.password)).to eq(@user) }
    end

    describe "with invalid password" do
      before do
        @user.save
      end

      let(:found_user) { described_class.find_by(email: @user.email) }

      it { expect(found_user.authenticate("invalid")).to be_falsey }
    end
  end
end
