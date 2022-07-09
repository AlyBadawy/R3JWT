require "rails_helper"

RSpec.describe "Accounts", type: :request do
  describe "POST /account" do
    it "returns http success" do
      post "/api/account"
      expect(response).to have_http_status(:success)
    end
  end

  describe "PUT /account" do
    it "returns http success" do
      get "/api/account"
      expect(response).to have_http_status(:success)
    end
  end

  describe "DELETE /account" do
    it "returns http success" do
      delete "/api/account"
      expect(response).to have_http_status(:success)
    end
  end
end
