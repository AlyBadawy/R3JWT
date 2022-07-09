require "rails_helper"

RSpec.describe AccountController, type: :routing do
  describe "routing" do
    it "routes to #create" do
      expect(post: "/api/account").to route_to("account#create")
    end

    it "routes to #update" do
      expect(put: "/api/account").to route_to("account#update")
    end

    it "routes to #destroy" do
      expect(delete: "/api/account").to route_to("account#destroy")
    end
  end
end
