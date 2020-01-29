require 'rails_helper'

# If you need to generate this file after your controller has already 
# been created, use:
# rails g rspec:controller job_posts

RSpec.describe JobPostsController, type: :controller do

    def current_user
        @current_user ||= FactoryBot.create(:user)
    end

    def unauthorized_user
        @other_user ||= FactoryBot.create(:user)
    end

    describe '#new' do
        context 'with no user signed in' do 
            it 'should redirect to session#new' do
                get :new 
                expect(response).to redirect_to(new_session_path)
            end 
            it 'sets a flash danger message' do 
                get :new
                expect(flash[:danger]).to be
            end
        end
        context 'with user signed in' do
            before do 
                session[:user_id] = current_user.id
            end
            it 'should render the new template' do
                # GIVEN
                # Defaults
                # WHEN 
                # Making a GET request to the new action 
                get(:new)
                # THEN
                # The `response` contains the rendered template of `new`
                #
                # The `response` object is available in any controller. It 
                # is similar to the `response` available in Express 
                # Middleware, however we rarely interact with it directly in 
                # Rails. RSpec makes it available when testing 
                # so that we can verify its contents. 
                
                # Here we verify with the `render_template` matcher that it 
                # contains the right rendered template. 
                expect(response).to(render_template(:new)) 
            end

            it 'should set an instance variable with a new job post' do
                get(:new)

                # assigns(:job_post)
                # Return the value of an instance variable @job_post 
                # from the instance of our JobPostsController. 
                # Only available if we have added the 
                # gem 'rails-controller-testing
                
                expect(assigns(:job_post)).to(be_a_new(JobPost))
                # The above matcher will verify that the expected value 
                # is a new instance of the JobPost Class(/Model)
            end
        end
    end

    describe '#create' do
        
        def valid_request 
            # The post method below simulates an HTTP request to 
            # the create action of the JobPostsController using 
            # the POST verb. 

            # This effectively simulates a user filling out a new
            # form in the browser and pressing submit. 
            post(:create, params: { job_post: FactoryBot.attributes_for(:job_post)})
        end
        context 'with no user signed in' do 
            it 'should redirect to session#new' do
                valid_request 
                expect(response).to redirect_to(new_session_path)
            end 
            it 'sets a flash danger message' do 
                valid_request
                expect(flash[:danger]).to be
            end
        end
        context 'with user signed in' do
            # Use `before` to run a block of code before all tests 
            # inside of the block it is defined in. In this case, the
            # below block will run before the tests within this 
            # context 'with user signed in' block
            before do
                # @current_user = FactoryBot.create(:user)
                # To simulate signing in a user, set a `user_id`
                # in the session. RSpec makes a controller's session 
                # available inside your tests
                session[:user_id] = current_user.id
            end
            # `context` the functionally teh same as `describe`, 
            # but we generally use it to organize groups of 
            # branching code paths
            context 'with valid parameters' do

                it 'should create a new job_post in the db' do
                    count_before = JobPost.count
                    valid_request
                    count_after = JobPost.count 
                    expect(count_after).to eq(count_before + 1)
                end
                it 'should redirect to the show page of that post' do
                    valid_request
                    job_post = JobPost.last
                    expect(response).to(redirect_to(job_post_path(job_post)))
                end
                it 'associates the current_user to the created JobPost' do
                    valid_request
                    job_post = JobPost.last
                    expect(job_post.user).to eq(current_user)
                end
            end

            context 'with invalid parameters' do
                def invalid_request 
                    post(:create, params: { job_post: FactoryBot.attributes_for(:job_post, title: nil)})
                end
                it 'should assign an invalid job_post as an instance variable' do 
                    invalid_request
                    expect(assigns(:job_post)).to be_a(JobPost)
                    expect(assigns(:job_post).valid?).to be(false)
                end
                it 'should render the new template' do 
                    invalid_request
                    expect(response).to(render_template(:new)) 
                end
                it 'should not create a job post in the db' do 
                    count_before = JobPost.count
                    invalid_request
                    count_after = JobPost.count 
                    expect(count_after).to eq(count_before)
                end
            end
        end
    end

    describe '#show' do 
        it 'render the show template' do 
            # GIVEN 
            # A job post in the db 
            job_post = FactoryBot.create(:job_post)
            # WHEN 
            # A GET request is made to /job_posts/:id
            get(:show, params: {id: job_post.id})
            # THEN
            # The response contains the rendered show template
            expect(response).to render_template(:show)
        end
        it 'should set an instance variable job_post for the shown object' do 
            # GIVEN 
            # A job post in the db 
            job_post = FactoryBot.create(:job_post)
            # WHEN 
            # A GET request is made to /job_posts/:id
            get(:show, params: {id: job_post.id})
            expect(assigns(:job_post)).to eq(job_post)
        end
    end

    describe '#destroy' do
         context 'with no user signed in' do 
            before do 
                job_post = FactoryBot.create(:job_post)
                delete(:destroy, params: {id: job_post.id})
            end
            it 'should redirect to session#new' do
                expect(response).to redirect_to(new_session_path)
            end 
            it 'sets a flash danger message' do 
                expect(flash[:danger]).to be
            end
        end
        context 'with signed in user' do 
            before do 
                session[:user_id] = current_user.id
            end
            context 'as non-owner' do 
                it 'redirects to job post show' do 
                    job_post = FactoryBot.create(:job_post)
                    delete(:destroy, params: {id: job_post.id})
                    expect(response).to redirect_to(job_post_path(job_post))
                end
                it 'sets a flash danger' do
                    job_post = FactoryBot.create(:job_post)
                    delete(:destroy, params: {id: job_post.id})
                    expect(flash[:danger]).to be
                end
                it 'does not remove a job post' do
                    job_post = FactoryBot.create(:job_post)
                    delete(:destroy, params: {id: job_post.id})
                    expect(JobPost.find_by(id: job_post.id)).to eq(job_post)
                end  
            end
            context 'as owner' do 
                it 'removes a JobPost from the database' do 
                    job_post = FactoryBot.create(:job_post, user: current_user)
                    delete(:destroy, params: {id: job_post.id})
                    expect(JobPost.find_by(id: job_post.id)).to be(nil)
                end
                it 'redirects to the job posts index' do
                    job_post = FactoryBot.create(:job_post, user: current_user)
                    delete(:destroy, params: {id: job_post.id})
                    expect(response).to redirect_to job_posts_path
                end 
            end
        end
    end

    describe "#edit" do

        context "with no user signed in" do
            it "redirects to the sign in page" do
                job_post = FactoryBot.create(:job_post, user: current_user)
                get :edit, params: { id: job_post.id }
                expect(response).to redirect_to new_session_path
            end
        end

        context "with user signed in" do
            context "with authorized user" do
                before do
                    session[:user_id] = current_user.id
                    @job_post = FactoryBot.create(:job_post, user: current_user)
                    get :edit, params: { id: @job_post.id }
                end

                it "renders the edit template" do
                    expect(response).to render_template :edit
                end

                it "sets an instance variable based on the post id that is passed" do
                    expect(assigns(:job_post)).to eq(@job_post)
                end
            end

            context "with unauthorized user" do
                before do
                    session[:user_id] = unauthorized_user.id
                    job_post = FactoryBot.create(:job_post, user: current_user)
                    get :edit, params: { id: job_post.id }
                end

                it "redirects to the root path" do
                    expect(response).to redirect_to root_path
                end

                it "sets a flash danger message" do
                    expect(flash[:danger]).to be
                end
            end
        end
    end

    describe "#update" do

        context "with user signed in" do
            context "with authorized user" do
                before do
                session[:user_id] = current_user.id
                end
                context 'with valid parameters' do

                    it "updates the job post record with new attributes" do
                        job_post = FactoryBot.create(:job_post, user: current_user)
                        new_title = "#{job_post.title} Plus Changes!"
                        patch :update, params: {id: job_post.id, job_post: {title: new_title}}
                        expect(job_post.reload.title).to eq(new_title)
                    end

                    it "redirect to the job post show page" do
                        job_post = FactoryBot.create(:job_post, user: current_user)
                        new_title = "#{job_post.title} plus changes!"
                        patch :update, params: {id: job_post.id, job_post: {title: new_title}}
                        expect(response).to redirect_to(job_post)
                    end
                end

                context 'with invalid parameters' do
                    def invalid_request
                        patch :update, params: {id: @job_post.id, job_post: {title: nil}}
                    end

                    it "doesn't update the job post with new attributes" do
                        @job_post = FactoryBot.create(:job_post, user: current_user)
                        expect { invalid_request }.not_to change { @job_post.reload.title }
                    end

                    it "renders the edit template" do
                        @job_post = FactoryBot.create(:job_post, user: current_user)
                        invalid_request
                        expect(response).to render_template(:edit)
                    end
                end
            end

            context "with unauthorized user" do
                before do
                    session[:user_id] = unauthorized_user.id
                    job_post = FactoryBot.create(:job_post, user: current_user)
                    patch :update, params: {id: job_post.id, job_post: {title: "New title that shouldn't be updated anyways"}}
                end

                it "redirects to the root path" do
                    expect(response).to redirect_to root_path
                end

                it "sets a flash danger message" do
                    expect(flash[:danger]).to be
                end
            end
        end
    end

    describe '#index' do

        before do
            get :index
        end

        it "renders the index template" do
            expect(response).to render_template(:index)
        end

        it "assigns an instance variable to all created news articles (sorted by created_at)" do
            job_post_1 = FactoryBot.create(:job_post)
            job_post_2 = FactoryBot.create(:job_post)
            expect(assigns(:job_posts)).to eq([job_post_2, job_post_1])
        end
    end

end
