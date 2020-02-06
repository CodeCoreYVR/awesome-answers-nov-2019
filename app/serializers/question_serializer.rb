class QuestionSerializer < ActiveModel::Serializer
  # Active Model Serializer Docs:
  # https://github.com/rails-api/active_model_serializers/blob/v0.10.6/docs/README.md

  # Use the `attributes` method to specify which 
  # methods of a model to include in the serialization output.
  # All columns of a model have a corresponding attr_reader (getter) method, so we can filter this way as well. 
  attributes :id, :title, :body, :created_at, :updated_at, :view_count, :like_count

  # To include associated models, use the same named methods
  # for creating associations. You can rename the association 
  # with the argument `key:`, which is only going to show in
  # the rendered json (won't effect the name of the 
  # association anywhere else).
  belongs_to :user, key: :author
  has_many :answers

  # You can create methods inside the serializer to include
  # custom data in the json serialization. When doing so 
  # make sure to include the name of the method in the 
  # `attributes` call.
  def like_count
    # object will refer to the instance of the model being 
    # serialized. Use it where you would use `self` in the 
    # model class.
    object.likes.count
  end

  # To customize a serializer for associated models you can
  # define a serialzier within  the current serializer
  class AnswerSerializer < ActiveModel::Serializer
    attributes :id, :body, :created_at, :updated_at
    belongs_to :user, key: :author
  end

end
