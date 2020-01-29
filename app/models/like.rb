class Like < ApplicationRecord
  belongs_to :question
  belongs_to :user

  # The following will ensure that the quetion_id / user_id
  # combination is unique.
  # Said in plain english, this is need to make sure that 
  # a user can only like a question once. 
  validates(
    :question_id, 
    uniqueness: {
      scope: :user_id,
      message: "has already been liked"      
    }
  )
end
