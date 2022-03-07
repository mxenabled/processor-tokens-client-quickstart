# frozen_string_literal: true

# Helps control the CRUD for Users
class UsersController < ApplicationController
  USERS_ERROR = 'The demo app could not get users from MX, please double check your Configuration'

  def index
    # Set up the UI variables
    @users = []
    @error = nil

    begin
      mx_response = MxApi.new.fetch_users
      @users = mx_response
    rescue ::MxPlatformRuby::ApiError => e
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

    render_404 if @user.nil?
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
