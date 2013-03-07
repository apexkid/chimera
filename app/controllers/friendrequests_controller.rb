class FriendrequestsController < ApplicationController

	before_filter :authenticate_user!

	def index
		@received_friend_requests = current_user.requested_friends(true)
	end

	def create
		@user = User.find_by_id(params[:userid])
		if @user
			current_user.send_friend_request!(@user)
			current_user.follow!(@user)
			redirect_to @user.profile
		else
			redirect_to root_path
		end
	end

	def destroy
		@user = User.find_by_id(params[:userid])
		if @user
			current_user.reject_friend_request!(@user)
			current_user.cancel_friend_request!(@user)
			redirect_to @user.profile
		else
			redirect_to root_path
		end
	end
end
