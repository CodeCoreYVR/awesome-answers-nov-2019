class Answer < ApplicationRecord
  belongs_to :user
  
  # Rails guide on Associations
  # https://guides.rubyonrails.org/association_basics.html

  # By default belons_to will create a validation 
  # such as:
  # `validates :question_id, presence: true`
  # It can be disabled by passing the option 
  # optional: true to the bleongs_to method ex:
  # belongs_to :question, optional: true

  # In association between two models, the model 
  # that has the belongs_to method call is always the 
  # one whos table contains the foreign key column (i.e. question_id)
  belongs_to :question
  # The following instance methods are added to 
  # the answer model by the line belongs_to :question

  # question
  # question=(associate)
  # build_question(attributes = {})
  # create_question(attributes = {})
  # create_question!(attributes = {})
  # reload_question

  # The above are instance methods that simplify interaction
  # with the associated question

  validates :body, presence: true


end
