require 'rails_helper'
# To generate this file after you have already created
# the model run:

# rails g rspec:model JobPost
#
# To run your tests with rspec, do:
# rspec

# To get detailed information about the running tests, do:
# rspec -f d

RSpec.describe JobPost, type: :model do

  # The 'describe' is used to group related tests together. 
  # It is an organizational tool. 
  # All of the grouped tests should be written inside the 
  # block of the method. In this case all of our validation 
  # tests will go in the block below. 
  describe "validates" do
    # `it` is another Rspec keyword which is used to define an
    # 'Example' (test case). The string argument is meant to 
    # describe what specific behaviour should happen inside the 
    # it block. 
    it("should require a title") do
      # GIVEN 
      # An instance of a job post without a title
      job_post = JobPost.new
      # WHEN 
      # Validations are triggered. 
      job_post.valid?

      # THEN
      # We expect there to be an error related to the title 
      # in the errrors object. 
      expect(job_post.errors.messages).to(have_key(:title)) 
    end

    it("should require a unique title") do
      # Given 
      # Given one job post in the db and an instance of job post 
      # ith the same title 
      persisted_jp = FactoryBot.create(:job_post)
      jp = JobPost.new(title: persisted_jp.title)

      # When: validations are triggered 
      jp.valid? 

      # Then: We get an error on title 
      expect(jp.errors.messages).to(have_key(:title))
      expect(jp.errors.messages[:title]).to(include('has already been taken'))
    end
  
  end

  # This describe should contain an example group of tests.
  # In this case, a group of tests that test the search
  # class method of JobPost
  # As per Ruby docs, methods that are described with a "." in front
  # are class method while those that are describe with a "#" in front
  # are instance methods.
  describe ".search" do
    # JobPost.search("Web") # returns jobs with "Web" in their title
    # or description
    # JobPost.search("Agriculture")
    it("should return job posts containing the query ignoring letter casing") do
      # GIVEN
      # 3 job posts in the database
      job_post_a = FactoryBot.create(:job_post, title: "Software Engineer")

      job_post_b = FactoryBot.create(:job_post, title: "Something without keyword", description: "Something without keyword")

      job_post_c = FactoryBot.create(:job_post, description: "develop software")

      # WHEN
      # Searching for "software"
      results = JobPost.search("software")

      # THEN
      # JobPost A & C are returned


      # Use the "expect" method instead of "assert_*" to write
      # assertions.
      # It takes a single argument which is actual value or the
      # one to be tested. We call the "to" method on the object
      # returns with a matcher to perform the verification of the value.
      expect(results).to(eq([job_post_a, job_post_c]))
    end

  end

end
