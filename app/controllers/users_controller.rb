class UsersController < ApplicationController
  def index
    @users = User.all
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
    external_id = @user.create_external_user
    @user.external_id = external_id

    if external_id && @user.save
      redirect_to @user
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
    @user.destroy

    redirect_to "/users/index", status: :see_other
  end

  private
    def user_params
      params.require(:user).permit(:name, :password)
    end
end
