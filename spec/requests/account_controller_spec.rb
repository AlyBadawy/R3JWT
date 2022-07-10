require "rails_helper"

RSpec.describe AccountController, type: :request do
  let(:valid_attributes) {
    { username: "user-test", email: "test1@example2.com", password: "Passw0rd" }
  }

  let(:invalid_attributes) {
    { username: "user1", email: "invalid", password: "123" }
  }

  describe "POST /account" do
    context "with valid attributes" do
      it "creates a new User" do
        expect {
          post "/api/account",
               params: { user: valid_attributes }, as: :json
        }.to change(User, :count).by(1)
      end

      it "renders a JSON response with the new user" do
        post "/api/account", params: { user: valid_attributes }, as: :json
        expect(response).to have_http_status(:created)
        parsed_body = JSON.parse(response.body)
        expect(parsed_body["data"]["type"]).to eq("user")
      end
    end

    context "with invalid aatributes" do
      it "doesn't create a new User" do
        expect {
          post "/api/account",
               params: { user: invalid_attributes }, as: :json
        }.not_to change(User, :count)
      end

      it "renders a JSON response with the error" do
        post "/api/account", params: { user: invalid_attributes }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        parsed_body = JSON.parse(response.body)
        expect(parsed_body).to have_key("errors")
        expect(parsed_body["errors"].first["detail"]).to eq("Email is invalid")
      end
    end
  end

  describe "PUT /account" do
    it "returns http success" do
      get "/api/account"
      expect(response).to have_http_status(:success)
    end
  end

  describe "DELETE /account" do
    context "with valid jwt"
    it "returns http success" do
      delete "/api/account"
      expect(response).to have_http_status(:success)
    end
  end
end
