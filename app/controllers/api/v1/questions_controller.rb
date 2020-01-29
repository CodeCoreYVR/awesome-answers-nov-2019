class Api::V1::QuestionsController < Api::ApplicationController
    before_action :authenticate_user!, except: [:index, :show]

    def create 
        question = Question.new question_params 
        question.user = current_user 
        if question.save 
            render json: { id: question.id }
        else 
            render(
                json: { errors: question.errors }, 
                status: 422 # Unprocessable Entity
            )
        end
    end

    def index 
        questions = Question.order(created_at: :desc)
        # This allows us to use the 
        # QuestionCollectionSerlializer to render json of 
        # questions in this list in order to keep the data 
        # limited to the minimum we need.
        render json: questions, each_serializer: QuestionCollectionSerializer    
    end

    def show 
        question = Question.find(params[:id])
        render json: question#, include: ['answers.author']
    end

    private

    def question_params
        params.require(:question).permit(:title, :body)
    end

end
