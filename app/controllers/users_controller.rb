class UsersController < ApplicationController

  before_action :set_user, only: [:edit, :update]

  def new
    @user = User.new
  end

  def edit
    if current_user.role?(:admin)
      @user = current_user
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to home_path
    else
      render :action => "new"
    end
  end

  def update
    if current_user.role?(:admin)
      @user = current_user
      if @user.update_attributes(user_params)
        redirect_to(@user, :notice => 'User was successfully updated.')
      else
        render :action => "edit"
      end
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :employee_id)
  end

  def set_user
    current_user
  end

end