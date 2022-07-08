require "rails_helper"

RSpec.describe Login, type: :model do
  describe "validations" do
    subject { build(:login) }

    it { is_expected.to validate_presence_of(:jwt) }
    it { is_expected.to validate_presence_of(:refresh_token) }
    it { is_expected.to validate_presence_of(:logged_out) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end
end
