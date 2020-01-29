class AnswerMailer < ApplicationMailer
    def new_answer(answer)
    @answer = answer
    @question = answer.question
    @owner = @question.user
    mail(
        to: @owner.email,
        subject: 'You got a new answer'
    )
    end
end
