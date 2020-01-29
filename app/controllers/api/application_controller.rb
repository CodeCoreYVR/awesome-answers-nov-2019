# This file was generated with the command: 
# rails g controller api::application --skip-template-engine
class Api::ApplicationController < ApplicationController
    # When making POST, DELETE & PATCH requests to our
    # controllers, Rails requires that an authenticity token
    # is included as part of our params. Normally Rails
    # will add this to any form that generates form helper methods
    # i.e. form_with, form_for, form_tag. This prevents third parties
    # from making such requests to our Rails app. It's a security measure
    # that is unneccessary in the context of a Web API.
    skip_before_action(:verify_authenticity_token)

    private 

    def authenticate_user!
        unless current_user.present? 
            render json: { status: 401 }, status: 401
        end
    end
end
