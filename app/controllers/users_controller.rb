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

    if @user.save
      redirect_to @user
    else
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
