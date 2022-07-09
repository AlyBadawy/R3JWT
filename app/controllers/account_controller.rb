class AccountController < ApplicationController
  def create
    @user = User.new(user_params)
    if @user.save
      render jsonapi: @user, status: :created
    else
      render jsonapi_errors: @user.errors, status: :unprocessable_entity
    end
  end

  def update
  end

  def destroy
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
