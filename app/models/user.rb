class User < ApplicationRecord
    has_many :job_posts, dependent: :destroy
    has_many :questions, dependent: :nullify
    has_many :answers, dependent: :nullify
    has_many :likes, dependent: :destroy 
    # The `has_many through:` argument takes the name of another
    # association created with has_many :association_name. 
    # If you were to use has_many :questions, through: :likes then 
    # you will have two has_many :questions. 
    # To fix this we can give the association a different name
    # and specify the `source` option so that Rails will be able to 
    # figure out what the other end of the association actually refers to
    # Note: `source` has to match a belongs_to association statement 
    # in the join model (`like` in this case).
    has_many :liked_questions, through: :likes, source: :question

    #created using rails g model user first_name last_name email password_digest

    #They are all strings so we didn’t have to specify type. Note that we must call the field 
    #password_digest to make use of the Rails build-in user authentication feature

    #we can optionally add an index on the email field to the migration. This because we 
    #will be doing searches on the users table by the email of the user. Having an index on the email field speeds up such queries. We can optionally add unique: true option to the index which enforces uniqueness at the database level.

    #Add an `index` to columns that you query often.  It'll improve the performance that query significantly  as the grows in size. An index achieves this by creating  an ordered list (a binary tree technically) that gives the  database a faster way to search for certain values in that column  As an analogy think of an index of a book vs.  just flipping through the pages



    validates :email, presence: true, uniqueness: true,
    format: /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
    #Where I got my regex 78https://stackoverflow.com/questions/22993545/ruby-email-validation-with-regex
    has_secure_password
    # Provides user authentication features on the model
    # it's called in. Requires a column named `password_digest`
    # and the gem `bcrypt`
    # - It will add two attribute accessors for `password`
    #   and `password_confirmation`
    # - It will add a presence validation for the `password`
    #   field.
    # - It will save passwords assigned to `password`
    #   using bcrypt to hash and store it in the
    #   the `password_digest` column meaning that we'll
    #   never store plain text passwords.
    # - It will add a method named `authenticate` to verify
    #   a user's password. If called with the correct password,
    #   it will return the user. Otherwise, it will return `false`
    # - The attr accesssor `password_confirmation` is optional.
    #   If it is present, a validation will verify that it is
    #   identical to the `password` accessor.

    has_many :sent_gifts, class_name: 'Gift', foreign_key: :sender_id, dependent: :nullify
    has_many :received_gifts, class_name: 'Gift', foreign_key: :receiver_id, dependent: :nullify


    def full_name
        "#{first_name} #{last_name}".strip.squeeze
    end

end
