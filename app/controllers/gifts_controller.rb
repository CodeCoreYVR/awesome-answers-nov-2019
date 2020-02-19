class GiftsController < ApplicationController
    before_action :authenticate_user!

    def new
        @user = User.find params[:user_id]
        @gift = Gift.new
    end

    def create
        @user = User.find params[:user_id]
        @gift = Gift.new amount: params[:gift][:amount],
                         sender: current_user,
                         receiver: @user
        
        if @gift.save
            redirect_to new_gift_payment_path(@gift), notice: "Please Make a Payment"
        else 
            render :new
        end
    end
end
