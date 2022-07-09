require "rails_helper"

RSpec.describe TokenHelper, type: :helper do
  describe "#payload_from_session" do
    it "returns valid payload" do
      session = create(:session)
      data = described_class.payload_from_session session
      expect(data.keys.count).to be(4)
      expect(data.keys).to eq([:data, :exp, :iss, :jti])
    end
  end

  describe "#jwt_from_payload" do
    it "returns valid JWT" do
      session = create(:session)
      payload = described_class.payload_from_session session
      jwt = described_class.jwt_from_payload payload
      expect(jwt.split(".").count).to eq(3)
    end
  end

  describe "#session_from_valid_jti" do
    context "when user is logged in" do
      it "returns a session from jti" do
        session = create(:session)
        jti = session.id
        expect(described_class.session_from_valid_jti(jti)).to eq(session)
      end
    end

    context "when user is logged out" do
      it "returns nil" do
        session = create(:session, :logged_out)
        jti = session.id
        expect(described_class.session_from_valid_jti(jti)).to be_nil
      end
    end
  end

  describe "#session_from_valid_refresh_token" do
    context "when expiry timeframe didn't pass" do
      it "returns a valid session" do
        user = create(:user, username: "valid_user_1", password: "password123")
        data = AuthHelper.login("valid_user_1", "password123")
        session = described_class.session_from_valid_refresh_token(data[:jwt], data[:refresh_token])
        expect(session.user).to eq(user)
      end
    end

    context "when expiry timeframe did pass" do
      it "returns a valid session" do
        create(:user, username: "valid_user_1", password: "password123")
        data = AuthHelper.login("valid_user_1", "password123")
        travel 10.days do
          session = described_class.session_from_valid_refresh_token(data[:jwt], data[:refresh_token])
          expect(session).to be_nil
        end
      end
    end
  end

  describe "#decode_token" do
    context "when expiry timeframe didn't pass" do
      it "returns a valid token" do
        create(:user, username: "valid_user_1", password: "password123")
        data = AuthHelper.login("valid_user_1", "password123")
        jwt = data[:jwt]
        expect(described_class.decode_token(jwt).first.keys.count).to eq(4)
        expect(described_class.decode_token(jwt).first.keys).to eq(["data", "exp", "iss", "jti"])
        # expect(described_class.decode_token(jwt).first[:exp].to_time
      end
    end

    context "when expiry timeframe did pass" do
      it "raises an error" do
        create(:user, username: "valid_user_1", password: "password123")
        data = AuthHelper.login("valid_user_1", "password123")
        jwt = data[:jwt]
        travel 2.hours do
          expect { described_class.decode_token(jwt) }.to raise_error(JWT::ExpiredSignature)
        end
      end
    end
  end

  describe "#decode_expired_token" do
    context "when expiry timeframe didn't pass" do
      it "returns a valid token" do
        create(:user, username: "valid_user_1", password: "password123")
        data = AuthHelper.login("valid_user_1", "password123")
        jwt = data[:jwt]
        expect(described_class.decode_expired_token(jwt).first.keys.count).to eq(4)
        expect(described_class.decode_expired_token(jwt).first.keys).to eq(["data", "exp", "iss", "jti"])
        # expect(described_class.decode_token(jwt).first[:exp].to_time
      end
    end

    context "when expiry timeframe did pass" do
      it "raises an error" do
        create(:user, username: "valid_user_1", password: "password123")
        data = AuthHelper.login("valid_user_1", "password123")
        jwt = data[:jwt]
        travel 2.hours do
          expect(described_class.decode_expired_token(jwt).first.keys.count).to eq(4)
          expect(described_class.decode_expired_token(jwt).first.keys).to eq(["data", "exp", "iss", "jti"])
        end
      end
    end
  end
end
