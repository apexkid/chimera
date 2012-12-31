class ProfilesController < ApplicationController
	
	before_filter :authenticate_user!, :except => :show

#	def new
#		if exists
#			render 'edit'
#		else
#			@profile = Profile.new
#			@title = "User profile"
#		end
#	end
#
	def create
		@profile = current_user.build_profile(params[:profile])
		if @profile.save
			flash[:success] = "Profile info updated"
			render 'show'
		else
			@title = "User profile"
			flash[:error] = "Something went wrong. Try again"
			render 'edit'
		end
	end

	def show
		@profile = Profile.find_by_id(params[:id])
		if @profile
			@title = "Profile"
		else
			flash[:notice] = "No such user exists"
			redirect_to root_path
		end
	end

	def edit
		@profile = Profile.find_by_user_id(current_user.id)
		@profile ||= Profile.new
    	@title = "Edit profile"
	end

	def update
		@profile = Profile.find_by_user_id(current_user.id)
		if current_user.profile.update_attributes(params[:profile])
			flash[:success] = "Profile updated"
			render 'show'
		else
			#flash[:notice] = "Something went wrong"
			@title = "Edit user"
			render 'edit'
		end
	end

	def destroy
	end	

	def index
		@profile = Profile.find_by_user_id(current_user.id)
		if @profile
			@title = "Profile"
		else
			@profile = Profile.new
			flash[:notice] = "Profile not created. Create it now."
			render 'edit'
		end
	end
end