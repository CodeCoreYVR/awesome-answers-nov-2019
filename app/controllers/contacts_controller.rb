# This file was generated with the command:
# rails g controller contacts
class ContactsController < ApplicationController
  def new
    # render :new
  end

  def create
    # render :create
    # all parameters from HTTP or URL come in a hash called `params`
    # params is a `hash with indifferent access` meaning that you can
    # access values using string or symbol keys so I can do
    # params[:name] or params['name'] (added feature by
    # Rails, not a standard Ruby feature)
    # When we define instance variable in actions such as `@name` we can
    # access them in the associated view file
    # i.e. `create.html.erb`
    @name = params[:name]
    @email = params[:email]
    @message = params[:message]
  end
end
