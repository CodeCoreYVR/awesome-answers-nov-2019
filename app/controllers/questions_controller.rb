class QuestionsController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
    before_action :find_question, only: [:edit,:update,:show, :destroy]
    before_action :authorize!, only: [:edit, :update, :destroy]

    def new
        @question=Question.new
    end

    def create
        @question = Question.new question_params
        @question.user = current_user
        if @question.save # perform validation and if succesful it will save indb
            flash[:notice] = 'Question Created Successfully'
            redirect_to question_path(@question.id)
        else
            render :new
        end
    end

    def edit    
    end

    def update
        if @question.update question_params
            flash[:notice] = 'Question updated Successfully'
            redirect_to question_path(@question.id)
        else
            render :edit
        end
    end

    def index 
        if params[:tag]
            @tag = Tag.find_or_initialize_by(name: params[:tag])
            @questions = @tag.questions.viewable.order(created_at: :desc)
        else
            @questions = Question.viewable.order(created_at: :desc)
        end
        respond_to do |format|
            format.html { render :index }
            format.json { render json: @questions }
            # format.csv { render plain: 'blah, blah, blah'}
        end
    end

    def show
        @new_answer = Answer.new
        @answers = @question.answers.order(created_at: :desc)
        # @question.view_count += 1
        # @question.save

        # The method `update_columns` works just like `update`. However,
        # it will skip validations, skip callbacks and not update `updated_at`.
        # Unless, you have a very good reason to use this DO NOT USE IT.

        @question.update_columns(view_count: @question.view_count + 1)
        @like = @question.likes.find_by(user: current_user)
        respond_to do |format|
            format.html { render }
            format.json { render json: @question }
            # format.csv { render plain: 'blah, blah, blah'}
        end
    end

    def destroy
        @question.destroy
        redirect_to questions_path
    end

    def liked 
        @questions = current_user.liked_questions.order('likes.created_at DESC')
    end

    private

    def find_question
        @question=Question.find params[:id]
    end
    def question_params
        # Use the `require` on the params object to retrieve
    # the nested hash of a key usually corresponding the name-value
    # pairs of a form.

    # Then, use `permit` to specify all input names that are allowed
    # as symbols.
        params.require(:question).permit(:title, :body, :tag_names)
    end

    def authorize! 
        unless can?(:crud, @question)
            redirect_to root_path, alert: 'Not Authorized' 
        end
    end

end
