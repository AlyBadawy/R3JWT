require "rails_helper"

RSpec.describe UsersController, type: :request do
  context "with valid admin session" do
    let(:valid_attributes) {
      { username: Faker::Internet.username(specifier: 5..10),
        email:    Faker::Internet.email,
        password: "Passw0rd" }
    }

    let(:invalid_attributes) {
      { username: "user1",
        email:    "invalid",
        password: "123" }
    }

    let(:valid_user_params) {
      { data: { attributes: { username:         Faker::Internet.username(specifier: 5..10),
                              email:            Faker::Internet.email,
                              password:         "Passw0rd",
                              current_password: "password123" } } }
    }

    let(:invalid_user_params) {
      { data: { attributes: { username:         "inv",
                              email:            "invalid",
                              password:         "Passw0rd",
                              current_password: "password123" } } }
    }

    before(:each) do
      username = Faker::Internet.username(specifier: 5..10)
      create(:user, username: username, password: "password123", admin: true)
      login_data = AuthHelper.login(username, "password123") # This creates a session
      jwt = login_data[:jwt]
      @admin_headers = { Authorization: "Bearer #{jwt}" }
    end

    describe "GET /index" do
      it "renders a successful response" do
        get users_url, headers: @admin_headers, as: :json
        expect(response).to be_successful
      end

      it "returns a Json array of users" do
        create_list(:user, 3)
        get users_url, headers: @admin_headers, as: :json
        parsed_body = JSON.parse(response.body)
        expect(response.content_type).to match(a_string_including("application/vnd.api+json"))
        expect(parsed_body["meta"]["total"]).to eq(4)
        expect(parsed_body["data"][0]["type"]).to eq("user")
      end
    end

    describe "GET /show" do
      it "renders a successful response" do
        user = User.create! valid_attributes
        get user_url(user), headers: @admin_headers, as: :json
        expect(response).to be_successful
      end

      it "renders a valid user Json" do
        user = User.create! valid_attributes
        get user_url(user), headers: @admin_headers, as: :json
        parsed_body = JSON.parse(response.body)
        expect(response.content_type).to match(a_string_including("application/vnd.api+json"))
        expect(parsed_body["data"]["type"]).to eq("user")
        expect(parsed_body["data"]["attributes"]["email"]).to eq(user.email)
      end
    end

    describe "POST /create" do
      context "with valid parameters" do
        it "creates a new User" do
          expect {
            post users_url,
                 params: valid_user_params, headers: @admin_headers, as: :json
          }.to change(User, :count).by(1)
        end

        it "renders a JSON response with the new user" do
          post users_url,
               params: valid_user_params, headers: @admin_headers, as: :json
          parsed_body = JSON.parse(response.body)
          expect(response).to have_http_status(:created)
          expect(response.content_type).to match(a_string_including("application/vnd.api+json"))
          expect(parsed_body["data"]["type"]).to eq("user")
        end
      end

      context "with invalid parameters" do
        it "does not create a new User" do
          expect {
            post users_url,
                 params: invalid_user_params, headers: @admin_headers, as: :json
          }.not_to change(User, :count)
        end

        it "renders a JSON response with errors for the new user" do
          post users_url,
               params: invalid_user_params, headers: @admin_headers, as: :json
          parsed_body = JSON.parse(response.body)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(parsed_body).to have_key("errors")
        end
      end
    end

    describe "PATCH /update" do
      context "with valid parameters" do
        let(:new_user_attributes) {
          { data: { attributes: { username: "new_username", email: "new@email.com" } } }
        }

        it "updates the requested user" do
          user = User.create! valid_attributes
          patch user_url(user),
                params: new_user_attributes, headers: @admin_headers, as: :json
          user.reload
          expect(user.username).to eq "new_username"
          expect(user.email).to eq "new@email.com"
        end

        it "renders a JSON response with the user" do
          user = User.create! valid_attributes
          patch user_url(user),
                params: new_user_attributes, headers: @admin_headers, as: :json
          expect(response).to have_http_status(:ok)
          parsed_body = JSON.parse(response.body)
          expect(parsed_body["data"]["attributes"]["username"]).to eq("new_username")
          expect(parsed_body["data"]["attributes"]["email"]).to eq("new@email.com")
        end
      end

      context "with invalid parameters" do
        let(:invalid_user_attributes) {
          { data: { attributes: { username: "no", email: "invalid" } } }
        }

        it "renders a JSON response with errors for the user" do
          user = User.create! valid_attributes
          patch user_url(user),
                params: invalid_user_attributes, headers: @admin_headers, as: :json
          parsed_body = JSON.parse(response.body)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(parsed_body).to have_key("errors")
        end
      end
    end

    describe "DELETE /destroy" do
      it "destroys the requested user" do
        user = User.create! valid_attributes
        expect {
          delete user_url(user), headers: @admin_headers, as: :json
        }.to change(User, :count).by(-1)
      end

      it "returns a success status" do
        user = User.create! valid_attributes
        delete user_url(user), headers: @admin_headers, as: :json
        expect(response).to have_http_status :no_content
      end
    end
  end

  context "with valid user (but not admin) session" do
    before(:each) do
      username = Faker::Internet.username(specifier: 5..10)
      create(:user, username: username, password: "password123")
      login_data = AuthHelper.login(username, "password123") # This creates a session
      jwt = login_data[:jwt]
      @user_headers = { Authorization: "Bearer #{jwt}" }
    end

    describe "GET /index" do
      it "returns a 403 Forbidden status" do
        get users_url, headers: @user_headers, as: :json
<<<<<<< HEAD
=======

        binding.pry

>>>>>>> ab2ddee (Closes #20)
        expect(response).to have_http_status :forbidden
      end
    end
  end

  context "with no valid session" do
    describe "GET /index" do
      it "returns a 403 Forbidden status" do
        get users_url, as: :json
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
