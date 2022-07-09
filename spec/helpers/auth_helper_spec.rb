require "rails_helper"

RSpec.describe AuthHelper, type: :helper do
  describe "#login" do
    context "with valid credentials" do
      it "returns valid login information" do
        create(:user, username: "valid_user_1", password: "password123")
        data = described_class.login("valid_user_1", "password123")
        expect(data).to have_key(:jwt)
        expect(data).to have_key(:refresh_token)
        expect(data).to have_key(:exp)
      end

      it "creates a new record in the Session table" do
        create(:user, username: "valid_user_1", password: "password123")
        expect { described_class.login("valid_user_1", "password123") }.to change(Session, :count).by(1)
      end
    end

    context "with invalid credentials" do
      it "raises exception for invalid username" do
        create(:user, username: "valid_user_1", password: "password123")
        expect { described_class.login("invalid", "password123") }.to raise_error(AuthHelper::WrongCredentials)
      end

      it "raises exception for invalid password" do
        create(:user, username: "valid_user_1", password: "password123")
        expect { described_class.login("valid_user_1", "invalid") }.to raise_error(AuthHelper::WrongCredentials)
      end
    end
  end

  describe "#refresh" do
    context "with valid credentials" do
      it "returns valid login information" do
        create(:user, username: "valid_user_1", password: "password123")
        data = described_class.login("valid_user_1", "password123")
        new_data = described_class.refresh(data[:jwt], data[:refresh_token])
        expect(new_data).to have_key(:jwt)
        expect(new_data).to have_key(:refresh_token)
        expect(new_data).to have_key(:exp)
      end

      it "doesn't create a new record in the Session table" do
        create(:user, username: "valid_user_1", password: "password123")
        data = described_class.login("valid_user_1", "password123")
        expect { described_class.refresh(data[:jwt], data[:refresh_token]) }.not_to change(Session, :count)
      end
    end

    context "with invalid credentials" do
      it "raises an exception for invalid JWT" do
        create(:user, username: "valid_user_1", password: "password123")
        data = described_class.login("valid_user_1", "password123")
        expect { described_class.refresh("invalid", data[:refresh_token]) }.to raise_error(JWT::DecodeError)
      end

      it "raises an exception for invalid Refresh Token" do
        create(:user, username: "valid_user_1", password: "password123")
        data = described_class.login("valid_user_1", "password123")
        expect { described_class.refresh(data[:jwt], "invalid") }.to raise_error(AuthHelper::WrongCredentials)
      end
    end
  end

  describe "#logout" do
    context "with valid credentials" do
      it "returns valid login information" do
        create(:user, username: "valid_user_1", password: "password123")
        data = described_class.login("valid_user_1", "password123")
        new_data = described_class.logout(data[:jwt])
        expect(new_data).to be(true)
      end
    end

    context "with invalid credentials" do
      it "raises an exception for invalid JWT" do
        create(:user, username: "valid_user_1", password: "password123")
        described_class.login("valid_user_1", "password123")
        expect { described_class.logout("invalid") }.to raise_error(JWT::DecodeError)
      end
    end
  end
end
