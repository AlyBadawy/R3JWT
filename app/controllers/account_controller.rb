class AccountController < ApplicationController
  prepend_before_action :authenticate_user!, only: %i[update destroy]

  def create
    @user = User.new(user_params)
    if @user.save
      render jsonapi: @user, status: :created
    else
      render jsonapi_errors: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @current_user.authenticate_password(serialized_password["current_password"])
      if @current_user.update(serialized_params)
        render jsonapi: @current_user
      else
        render jsonapi_errors: @current_user.errors, status: :unprocessable_entity
      end
    else
      render json: { errors: ["Invalid password"] }, status: :forbidden
    end
  end

  def destroy
    if @current_user.authenticate_password(params[:current_password])
      @current_user.destroy
    else
      render json: { errors: ["Invalid password"] }, status: :forbidden
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def serialized_params
    jsonapi_deserialize(params, only: [:username, :email, :password, :password_confirmation])
  end

  def serialized_password
    jsonapi_deserialize(params, only: [:current_password])
  end
end
