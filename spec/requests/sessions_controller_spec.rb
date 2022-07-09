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
end
