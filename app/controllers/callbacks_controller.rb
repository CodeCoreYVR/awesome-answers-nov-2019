class CallbacksController < ApplicationController
    def index
        oauth_data = request.env["omniauth.auth"]
        user = User.find_from_oauth(oauth_data)
        user ||= User.create_from_oauth(oauth_data)
        if user.valid?
            session[:user_id] = user.id
            flash[:success] = "Than you for signing in with #{oauth_data["provider"].capitalize}"
        else
            flash[:danger] = user.errors.full_messages.join(", ")
        end
        redirect_to root_path
    end
end
