class SubscribersController < ApplicationController

	before_filter :authenticate_user!

	def index
		@title = "Subscribers"
		@user = User.find_by_id(params[:user_id])
		if @user
			@followers = @user.followers
			@following = @user.following
		else
			flash[:notice] = "No such user exists"
			redirect_to root_path
		end
	end

	def create
		@user = User.find_by_id(params[:userid])
		if @user
			current_user.follow!(@user)
			redirect_to @user.profile
		else
			redirect_to root_path
		end
	end

	def destroy
		@user = User.find_by_id(params[:userid])
		if @user
			current_user.unfollow!(@user)
			redirect_to @user.profile
		else
			redirect_to root_path
		end	
	end
end
