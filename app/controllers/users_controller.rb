class UsersController < ApplicationController
  before_action :set_user, only: %i[ show update destroy ]
  before_action :authenticate_admin!
  # GET /users
  def index
    @users = User.all

    render jsonapi: @users
  end

  # GET /users/1
  def show
    render jsonapi: @user
  end

  # POST /users
  def create
    @user = User.new(serialized_params)

    if @user.save
      render jsonapi: @user, status: :created, location: @user
    else
      render jsonapi_errors: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/ -1
  def update
    if @user.update(serialized_params)
      render jsonapi: @user
    else
      render jsonapi_errors: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def serialized_params
    jsonapi_deserialize(params, only: [:username, :email, :password, :password_confirmation])
  end
end
