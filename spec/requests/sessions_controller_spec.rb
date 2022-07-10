require "rails_helper"

RSpec.describe SessionsController, type: :request do
  describe "POST /api/sessions" do
    context "with valid attributes" do
      it "creates a new Sessions" do
        create(:user, username: "test-user", password: "password123")
        expect {
          post "/api/sessions",
               params: { username: "test-user", password: "password123" }, as: :json
        }.to change(Session, :count).by(1)
      end

      it "renders required headers" do
        create(:user, username: "test-user", password: "password123")
        post "/api/sessions",
             params: { username: "test-user", password: "password123" }, as: :json
        expect(response.header).to have_key("Access-Token")
        expect(response.header).to have_key("Refresh-Token")
        expect(response.header).to have_key("Expire-At")
      end

      it "doesn't return any content" do
        create(:user, username: "test-user", password: "password123")
        post "/api/sessions",
             params: { username: "test-user", password: "password123" }, as: :json
        expect(response).to have_http_status(:no_content)
        expect(response.body).to eq ""
      end
    end

    context "with invalid attributes" do
      it "doesn't create a new Sessions" do
        create(:user, username: "test-user", password: "password123")
        expect {
          post "/api/sessions",
               params: { username: "test-user", password: "invalid" }, as: :json
        }.not_to change(Session, :count)
      end

      it "reutrn status code unauthorized" do
        create(:user, username: "test-user", password: "password123")
        post "/api/sessions",
             params: { username: "test-user", password: "invalid" }, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /api/sessions/:id", type: :request do
    context "with valid JWT Token and session id" do
      it "returns a success HTTP status" do
        create(:user, username: "test-user", password: "password123")
        login_data = AuthHelper.login("test-user", "password123")
        jwt = login_data[:jwt]
        delete "/api/sessions/current", headers: { Authorization: "Bearer #{jwt}" }
        expect(response).to have_http_status(:success)
      end

      it "marks the session as logged out" do
        user = create(:user, username: "test-user", password: "password123")
        login_data = AuthHelper.login("test-user", "password123")
        session = user.sessions.last
        expect(session.logged_out).to be_falsey
        jwt = login_data[:jwt]
        delete "/api/sessions/#{session.id}", headers: { Authorization: "Bearer #{jwt}" }
        session.reload
        expect(session.logged_out).to be_truthy
      end
    end

    context "with valid JWT and invalid session Id" do
      it "returns a 404 record not found error" do
        create(:user, username: "test-user", password: "password123")
        login_data = AuthHelper.login("test-user", "password123")
        jwt = login_data[:jwt]
        delete "/api/sessions/invlaid_id", headers: { Authorization: "Bearer #{jwt}" }
        expect(response).to have_http_status(:not_found)
      end
    end

    context "with invalid JWT token" do
      it "returns a 401 Unauthorized status" do
        delete "/api/sessions/current", headers: { Authorization: "Bearer invalid-token" }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
