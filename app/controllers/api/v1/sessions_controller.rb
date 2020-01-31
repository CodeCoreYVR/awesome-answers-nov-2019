class Api::V1::SessionsController < Api::ApplicationController

    def create 
        # user = User.find_by(email: params[:email])
        # if user&.authenticate(params[:password])
        #     session[:user_id] = user.id
        #     response.set_cookie "name", "hindreen"
        #     render json: {id: user.id}
        # else 
        #     render(
        #         json: { status: 404 }, 
        #         status: 404 # Not found
        #     )
        # end
        user = User 
                .find_by(email: params[:email])
                .try(:authenticate, params[:password])
        if user 
            session[:user_id] = user.id 
            render json: {
                status: :created,
                logged_in: true,
                user: user
            }
        else 
            render json: { status: 401 }
        end
    end

    def destroy 
        session[:user_id] = nil 
        render(json: { status: 200}, status: 200)
    end
end
