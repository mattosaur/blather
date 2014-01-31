class SessionsController < ApplicationController

	def new
	end

	def create
		user = User.find_by(email: params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			# sign the user in and redirect to the user's profile page
		else
			# create an error message and re-render the signin form
		end
	end

	def destroy
	end

end
