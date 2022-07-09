require "rails_helper"

RSpec.describe Login, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end
end
