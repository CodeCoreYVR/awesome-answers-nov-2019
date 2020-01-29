class SessionsController < ApplicationController

#We utilize the user.authenticate method which comes with the has_secure_password method. This method takes a password and hashes it the same way it was hashed the first time and  
#compares the outcome with password_digest. If the outcome is the same it means that the user has entered the correct password so the method returns true. If the password is not the same then the method will return false. This is because we can’t go from password_digest to a clear-text password. We can only go one way with Hashing algorithms.  
#The session object 
#If the user is found an authenticated properly then we authenticate the user by setting the session variable as in session[:user_id] = user.id  
#We user form_tag for the session new view template because we’re not really creating a model and don’t have Session model that stores to the database. 
 
# The `session` is an object useable in controllers 
# that uses cookies to store encrypted data. To sign 
# in a user, we store their `user_id` in the session for 
# later retrieval. 

    def new
    end

    def create
        user = User.find_by_email params[:email]
        if user&.authenticate(params[:password])
            session[:user_id] = user.id  
            redirect_to root_path, notice: "Logged In"
        else
            flash[:alert] = "Sorry, wrong email or password"
            render :new
        end
    end

    def destroy
        session[:user_id] = nil
        redirect_to root_path, notice: "Logged out!"
    end

    #In the controller we implement the destroy action which simply sets the sessions[:user_id] to nil making our user signed out.
    #We start by adding the destroy routes in our routes.rb file. We can make as a standard destroy route but then we will need to have an :id part of the route. This is not really needed or recommended in the case of the user. We have the user id stored in the session so we don’t really need to have it part of the url. Also it’s generally advisable to hide the user id whenever possible for security reasons. 
    #We can accomplish this by adding the destroy route with on: :collection option. Which makes the route without :id or :user_id in it.


    
end
