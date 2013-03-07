class FriendsController < ApplicationController

	before_filter :authenticate_user!

	def index
		@title = "My friends"
		@user = User.find_by_id(params[:user_id])
		if @user.nil?
			flash[:notice] = "No such user exists"
			redirect_to root_path
		else
			@friends = @user.friends
			@requested_friends = @user.requested_friends
			@pending_friends = @user.pending_friends
		end
	end

	def create
		@user = User.find_by_id(params[:userid])
		if @user
			current_user.accept_friend_request!(@user)
			redirect_to @user.profile
		else
			redirect_to root_path
		end
	end

	def destroy
		@user = User.find_by_id(params[:userid])
		if @user
			current_user.unfriend!(@user)
			current_user.unfolllow!(@user)
			redirect_to @user.profile
		else
			redirect_to root_path
		end			
	end
end

