require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/sessions/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/sessions/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/sessions/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/sessions/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
