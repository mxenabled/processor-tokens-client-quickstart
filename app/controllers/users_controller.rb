# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @users = MxApi.new.get_users
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
  end

  def destroy
    @user = User.get_user(params[:id])

    # Destroy the MX user before destroying our reference
    begin
      MxApi.new.delete_user(@user.guid)
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
