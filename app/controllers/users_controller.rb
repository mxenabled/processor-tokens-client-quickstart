class UsersController < ApplicationController
  def index
    # TODO: consider changing this to only get MX saved users?
    @users = User.all

    p MxApi.new.get_users
  end

  def new
    @user = User.new
  end

  def create
    puts(params)
    @user = User.new(user_params)

    # Attempt to get an external id from MX
    # For this app, we're requiring a user to have
    # an MX guid in order to create a user at all
    external_id = @user.create_external_user({name: @user.name})
    @user.external_id = external_id

    if external_id && @user.save
      redirect_to :action => 'index'
    else
      puts "Error: creation of local user failed"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])

    # Destroy the MX user before destroying our reference
    begin
      MxApi.new.delete_user(@user.external_id)
      @user.destroy
      puts "Destroyed user"
    rescue
      puts "Error deleting user"
    end

    redirect_to :action => 'index', status: :see_other
  end

  private
    def user_params
      params.require(:user).permit(:name, :password)
    end
end
