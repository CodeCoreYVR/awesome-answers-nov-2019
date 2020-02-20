class UsersController < ApplicationController
    def new
        @user = User.new
        
    end

    def create
        @user = User.new user_params
        if @user.save
            session[:user_id] = @user.id
            ## The `session` is an object useable in controllers  
            # that uses cookies to store encrypted data. To sign 
            # in a user, we store their `user_id` in the session for  
            # later retrieval.

            redirect_to root_path
        else
            render :new
        end
    end

    def show 
        @user = User.find(params[:id])
    end

    private
        def user_params
            params.require(:user).permit(
                :first_name, :last_name, :email, :password, :password_confirmation, :avatar
            )
        end

end
