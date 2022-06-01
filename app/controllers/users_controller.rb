class UsersController < ApplicationController
  before_action :authorize_admin

  def index
    @users = User.all
  end

  def show
    @user = user
  end

  def edit
    @user = user
  end

  def update
    @user = user
    @user.update!(user_params)

    render :show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create!(user_params)

    render :show
  end

  def destroy
    @user = user
    @user.destroy
    @users = User.all
    flash[:notice] = "Deleted #{@user.email}"

    render :index
  end

  private

  def authorize_admin
    return if current_user&.admin?

    render template: 'shared/not_authorized'
  end

  def user
    User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :admin)
  end
end
