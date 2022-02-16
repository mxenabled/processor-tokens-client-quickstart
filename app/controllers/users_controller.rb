class UsersController < ApplicationController
  def index
    # Get users from local database
    @users = User.all
    
    # TODO: consider changing this to only get MX saved users?
    # api_users = MxApi.new.get_users
    
    # @users = []
    # api_users.users.each do |user|
    #   puts user
    #     # See if user name was passed in
    #     name = ""
    #     begin
    #       metadata = JSON.parse user.metadata
    #       name = metadata.key?('name') ? metadata["name"] : "(no name provided)"
    #     rescue
    #       puts "Bad metadata"
    #     end

    #     report_user = User.new
    #     report_user.name = name
    #     report_user.external_id = user.guid

    #     @users.push(report_user)
    #     # @users.push({
    #     #   name: "na",
    #     #   external_id: user.guid
    #     # })
    # end
      
    # puts "===== single api response ====="
    # puts @users

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
