class UsersController < ApplicationController

	def index
		@title = "All users"
    	@users = User.paginate(:page => params[:page], :per_page => 10)
	end
end