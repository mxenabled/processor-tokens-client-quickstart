# frozen_string_literal: true

# Helps control the CRUD for Users
class UsersController < ApplicationController
  USERS_ERROR = "The demo app could not get users from MX, please double check your Configuration"

  def index
    # Set up the UI variables
    @users = []
    @error = nil

    api_response = MxApi.new.fetch_users

    if api_response.success
      @users = api_response.response
    else
      @error = USERS_ERROR
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    guid = @user.create_external_user

    if guid
      redirect_to action: 'show', id: guid
    else
      puts 'Error: creation of user failed'
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = User.get_user(params[:id])

    if @user.nil?
      render_404
    end
  end

  def destroy
    begin
      MxApi.new.delete_user(params[:id])
      puts 'Destroyed user'
    rescue StandardError
      puts 'Error deleting user'
    end

    redirect_to action: 'index', status: :see_other
  end

  private

  def user_params
    params.require(:name)
    params.require(:email)

    {
      name: params[:name],
      email: params[:email]
    }
  end
end
