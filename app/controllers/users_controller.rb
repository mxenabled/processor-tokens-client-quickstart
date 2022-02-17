class UsersController < ApplicationController
  def index    
    api_users = MxApi.new.get_users
    puts api_users
    
    @users = []
    api_users.users.each do |user|
      @users.push(
        MxHelper::UserAdapter.apiUserToModel(user)
      )
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    # Attempt to get an external id from MX
    # For this app, we're requiring a user to have
    # an MX guid in order to create a user at all
    guid = @user.create_external_user()

    if guid
      redirect_to :action => 'index'
    else
      puts "Error: creation of user failed"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    api_user = User.get_user(params[:id])
    @user = MxHelper::UserAdapter.apiUserToModel(api_user)
  end

  def destroy
    @user = User.get_user(params[:id])

    # Destroy the MX user before destroying our reference
    begin
      MxApi.new.delete_user(@user.guid)
      puts "Destroyed user"
    rescue
      puts "Error deleting user"
    end

    redirect_to :action => 'index', status: :see_other
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
