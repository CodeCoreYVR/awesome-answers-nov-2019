class JobPostsController < ApplicationController
    before_action :authenticate_user!, only: [:new, :create, :destroy, :edit, :update]

    def new 
        @job_post = JobPost.new
    end

    def create 
        @job_post = JobPost.new job_post_params  
        @job_post.user = current_user
        if  @job_post.save
            #redirect_to job_post_path(@job_post)
            # The above is equivalent to the below to redirect to a job_posts 
            # show page
            redirect_to @job_post
        else
            render :new
        end
    end

    def show 
        @job_post = JobPost.find(params[:id])
    end

    def destroy 
        job_post = JobPost.find(params[:id])
        if can? :crud, job_post
            job_post.destroy
            redirect_to job_posts_path
        else
            flash[:danger] = "Access Denied"
            redirect_to job_post_path(job_post)
        end
    end

    def index 
        @job_posts = JobPost.order(created_at: :desc)
    end

    def edit
        @job_post = JobPost.find(params[:id])
        unless can? :crud, @job_post
            flash[:danger] = "Access Denied"
            redirect_to root_path
        end  
    end

    def update
        @job_post = JobPost.find(params[:id])
        if can? :crud, @job_post
            if @job_post.update job_post_params
                flash[:notice] = 'job_post updated Successfully'
                redirect_to job_post_path(@job_post.id)
            else
                render :edit
            end
        else 
            flash[:danger] = "Access Denied"
            redirect_to root_path
        end
    end

    private 

    def job_post_params
        params.require(:job_post).permit(:title, :description, :min_salary, :max_salary)
    end
end
