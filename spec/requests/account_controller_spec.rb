require "rails_helper"

RSpec.describe AccountController, type: :request do
  let(:valid_attributes) {
    { username: "user-test", email: "test1@example2.com", password: "Passw0rd" }
  }

  let(:valid_user_attributes) {
    { data: { attributes: { username:         "user-test",
                            email:            "test1@example2.com",
                            password:         "Passw0rd",
                            current_password: "password123" } } }
  }

  let(:invalid_password_attributes) {
    { data: { attributes: { username:         "user-test",
                            email:            "test1@example2.com",
                            password:         "Passw0rd",
                            current_password: "invalid" } } }
  }

  let(:invalid_attributes) {
    { username: "user1", email: "invalid", password: "123" }
  }

  let(:invalid_user_attributes) {
    { data: { attributes: { username:         "user1",
                            email:            "invalid",
                            password:         "123",
                            current_password: "password123" } } }
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
    before(:each) do
      @user = create(:user, username: "test-user", password: "password123")
      @login_data = AuthHelper.login("test-user",
                                     "password123",
                                     Faker::Internet.ip_v4_address,
                                     "user-agent-1") # This creates a session
      @jwt = @login_data[:jwt]
    end

    context "with valid JWT and password" do
      context "with valid attributes" do
        it "returns http success" do
          put "/api/account", headers: { Authorization: "Bearer #{@jwt}" },
                              params: valid_user_attributes, as: :json
          expect(response).to have_http_status(:success)
        end

        it "renders a JSON response with the updated user" do
          old_password_digest = @user.password_digest
          put "/api/account", headers: { Authorization: "Bearer #{@jwt}" },
                              params: valid_user_attributes, as: :json
          parsed_body = JSON.parse(response.body)
          @user.reload
          expect(parsed_body["data"]["attributes"]["email"]).to eq(valid_attributes[:email])
          expect(parsed_body["data"]["attributes"]["username"]).to eq(valid_attributes[:username])
          expect(@user.password_digest).not_to eq old_password_digest
        end
      end

      context "with invalid attributes" do
        it "returns http status: unprocessable entity" do
          put "/api/account", headers: { Authorization: "Bearer #{@jwt}" },
                              params: invalid_user_attributes, as: :json
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context "with valid JWT and invalid password" do
      it "doesn't update the user" do
        old_user_state = @user
        put "/api/account", headers: { Authorization: "Bearer #{@jwt}" },
                            params: valid_user_attributes, as: :json
        @user.reload
        new_user_state = @user
        expect(new_user_state).to eq old_user_state
      end

      it "returns a forbidden status" do
        put "/api/account", headers: { Authorization: "Bearer #{@jwt}" },
                            params: invalid_password_attributes, as: :json
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "with invalid jwt" do
      it "returns a 401 unathoirzed" do
        put "/api/account", headers: { Authorization: "Bearer invalid-jwt" },
                            params: valid_user_attributes, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /account" do
    before(:each) do
      @user = create(:user, username: "test-user", password: "password123")
      @login_data = AuthHelper.login("test-user",
                                     "password123",
                                     Faker::Internet.ip_v4_address,
                                     "user-agent-1") # This creates a session
      @jwt = @login_data[:jwt]
    end

    context "with valid jwt and password" do
      it "returns no content" do
        delete "/api/account", headers: { Authorization: "Bearer #{@jwt}" }, params: { current_password: @user.password }
        expect(response).to have_http_status(:no_content)
        expect(response.body).to eq ""
      end

      it "deletes the user from the users table" do
        expect {
          delete "/api/account", headers: { Authorization: "Bearer #{@jwt}" },
                                 params:  { current_password: @user.password }
        }.to change(User, :count).by(-1)
      end
    end

    context "with valid jwt and invalid password" do
      it "returns http forbidden" do
        delete "/api/account", headers: { Authorization: "Bearer #{@jwt}" },
                               params:  { current_password: "invalid" }
        expect(response).to have_http_status(:forbidden)
      end

      it "doesn't deletes the user from the users table" do
        expect {
          delete "/api/account", headers: { Authorization: "Bearer #{@jwt}" },
                                 params:  { current_password: "invalid" }
        }.not_to change(User, :count)
      end
    end

    context "with invalid jwt" do
      it "returns a 401 unathoirzed" do
        delete "/api/account", headers: { Authorization: "Bearer invalid-jwt" },
                               params:  { current_password: @user.password }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
