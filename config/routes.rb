Rails.application.routes.draw do
  resources :users, shallow: true, only: [:new, :create, :show] do 
    # The shallow:true named argument will seperate routes
    # that require the parent from ones that don't.
    # Routes that require the parent (e.g. index, new, create)
    # will not change
    # Routes that don't require the parent (e.g. show, edit, update, destroy)
    # will have the parent prefix removed 
    # (e.g. /users/:user_id)
    resources :gifts, only: [:new, :create] do 
      resources :payments, only: [:new, :create]
    end
  end

  # namespace :api do 
  #   namespace :v1 do 
  #     get 'user/current'
  #   end
  # end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  # This defines a `route` rule that says when we receive a GET
  # request with the URL `/`, handle it with the `WelcomeController`
  # with the `index` action inside that controller.
  # get('/', { to: 'welcome#index', as: 'root'})
  root 'welcome#index'
  # Question Routes
  # get('/questions/new', to: 'questions#new', as: :new_question)
  # post('/questions', to:'questions#create', as: :questions)

  # get('/questions', to: 'questions#index')
  #   #new_question_path or new_question_url
  # get('/questions/:id', to: 'questions#show', as: :question)
  # #question_path(id) or question_url(id)
  # delete('/questions/:id', to: 'questions#destroy')
  # get('/questions/:id/edit', to: 'questions#edit', as: :edit_question)
  # patch('/questions/:id', to: 'questions#update')


  # resources method will gneerate all CRUD routes following
  # RESTful conventions for a resource. It will assume there 
  # is a controller named after the first argument pluralized
  # and PascalCased (i.e. QuestionsController)  
  resources :questions do 
    # Routes written inside of a block passed to a 
    # `resources` method will be pre-fixed by a path 
    # correpsonding to the passed in symbol (:questions)
    # In this case, all nested routes will be prfxied
    # with `/questions/:question_id`

    resources :answers, only: [:create, :destroy]
    # the shallow: true named argument will seperate 
    # routes that require the parent from those that don't 
    # Routes that require the parent (e.g. index, new, create) won't change (They will still be prefixed 
    # with /questions/:question_id )
    # Routes that don't require the parent (e.g. show, edit,
    # update, destroy) will have the parent prefix removed. 
    # Example: 
    # /questions/10/likes/9/edit becomes /likes/9/edit
    resources :likes, shallow: true, only: [ :create, :destroy]
    # resources :answers, except: [:new, :edit, :update, :index, :show]
    # Use the `on:` named argument to specify how a nested 
    # route will behave relative to its parent. 

    # `on: :collection` means that it acts on the entire 
    # resource. All questions in this case. 
    # new and create act on collection 
    
    # `on: :member` means that it acts on single resource. 
    # A single question in this case. edit, update, destroy
    # show are member routes  
    get :liked, on: :collection
    resources :publishings, only: :create
  end


  get '/contacts/new', to: 'contacts#new'
  post '/contacts', to: 'contacts#create'

  # resources :users, only: [:new, :create]

  resource :session, only: [:new, :create, :destroy]
  # `resource` is singular instead of `resources`. 
  # Unlike `resources`, `resource` will create routes 
  # that do CRUD operation on only one thing. There  
  # will be no index routes and no route will  
  # have a `:id` wild card. When using a singular resource,  
  # the controller must still be plural.
  
  get "/auth/github", as: :sign_in_with_github
  get "/auth/:provider/callback", to: "callbacks#index"

  resources :job_posts
  # The namespace method in Rails routes makes it so 
  # it will automatically look in a directory api, then 
  # in a directory v1 for QuestionsController.

  # The option `defaults: { format: :json }` will set 
  # `json` as the default response for all routes 
  # contained within the block of the namespace. 
  namespace :api, defaults: { format: :json } do 
    # /api...
    namespace :v1 do 
      # /api/v1...
      resources :questions
        #/api/v1/questions 
      resource :session, only: [:create, :destroy]
        #/api/v1/session 
      resources :users, only: [:create, :update] do 
        # api/v1/user/current
        get :current, on: :collection 
        # default
        # api/v1/user/:id/current
      end
    end
  end

  match(
    "/delayed_job",
    to: DelayedJobWeb,
    anchor: false,
    via: [:get, :post]
  )
  
end
