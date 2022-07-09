class SessionsController < ApplicationController
  def index
  end

  def show
  end

  def create
    username = params["username"]
    password = params["password"]
    ip = request.ip
    user_agent = request.user_agent

    login_data = AuthHelper.login(username, password, ip, user_agent)

    response.headers["access-token"] = login_data[:jwt]
    response.headers["refresh-token"] = login_data[:refresh_token]
    response.headers["expire-at"] = login_data[:exp]
  end

  def update
  end

  def destroy
  end
end
