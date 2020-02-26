# frozen_string_literal: true

class Ability
  include CanCan::Ability
  
  # Cancancan assumes you have a method called `current_user`
  # available in your Application Controller (which we do)
  # Cancan gets automatically initialized with current_user
  # passed to the initialize method.

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
      user ||= User.new # guest user (not logged in)
      # if user.admin?
      #   can(:manage, :all)
      # else
      #   can :read, :all
      # end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    # can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

    # Use the alias_action method to assign multiple action names 
    # to one action alias. This means that alias can be used 
    # in place of any of the supplied. 
    # In this case, :crud can be used, wherever :create, :read, 
    # :update or :destroy would be used.
    alias_action :create, :read, :update, :destroy, to: :crud
    # If the current_user is the owner of the question, they 
    # can manage it. 

    # To define a permission for a user, use the `can` method
    # inside of this class' initialize method. It takes the 
    # following arguments in order: 
    #  - The name of the action you're testing permission for 
    #    as a symbol (ex. :crud, :edit, :like, :favourite)
    #    manage is the only one that has any kind of special 
    #    significance 
    # - The class of an object we are testing the action against
    #   (ex. Question, Answer, User, etc.)
    # - A block that is used to determine whether or not a user 
    #   can perform said action on the resource If the block 
    #   returns true, the user can perform the action, otherwise 
    #   they can't.
  
    if user.is_admin?
      can :manage, :all
    end

    can(:crud, Question) do |question|
      question.user == user # current_user
    end

    can(:crud, Answer) do |answer|
      answer.user == user # || answer.question.user == user
    end

    can :crud, JobPost do |job_post|
      job_post.user == user
    end

    can :like, Question do |question|
      user.persisted? && question.user != user
    end
    # Can also write abilities like: 
    # can :manage, Question, user_id: user.id

    can :destroy, Like do |like|
      like.user = user
    end

    can(:publish, Question) do |question|
      question.user == user 
    end

  end
end
