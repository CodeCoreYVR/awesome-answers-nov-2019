# This file was generated with the command:
# rails g controller welcome --no-helper --no-assets
class WelcomeController < ApplicationController
  # Public methods inside controllers are called `actions`
  # So this is the index action
  def index
    # render :index
    # render 'index'

    # By default (convention) actions will render
    # view files within a folder that matches the controller name
    # so it will into a folder called app/views/welcome
    # And the view file should match the action name.
    # It will also include the format and the templating system
    # So the full filename will be something like:
    # action.format.templating_system
    # In our case:
    # index.html.erb

    # This is an example of convention over configuration.
    # We can render whatever we want. But if we stick to the
    # convention we don't have to write extra code.

    # ERB is the default templating system shipped with Rails.
  end
end
