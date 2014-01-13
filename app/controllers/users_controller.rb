class UsersController < ApplicationController
  def new
  	@user = User.new
  end

  def create
  	@user = User.new(params.require(:user).permit(:username, :password, :password_confirmation, :email))
  	if @user.save
      #Now log them in
      auto_login(@user)
  		redirect_to user_posts_path, :notice => "Member signed up!"
  	else
      flash_alert(@user, msg="Unable to create user")
  		render :new
  	end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update_user_email
    @user = User.find(params[:id])
    if @user.update_attribute(:email, params[:email])
      redirect_to user_posts_path, :notice => "Member info updated!"
    else
      flash.now.alert = "Unable to update member's info."
      render :edit
    end

  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params.require(:user).permit(:password, :password_confirmation, :email))
      redirect_to user_posts_path, :notice => "Member info updated!"
    else
      #flash.now.alert = "Unable to update user."
      flash_alert(@user, "Unable to update user.")
      render :edit
    end
    
  end
end
