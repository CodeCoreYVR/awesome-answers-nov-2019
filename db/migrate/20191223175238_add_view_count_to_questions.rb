class AddViewCountToQuestions < ActiveRecord::Migration[6.0]
  # To generate a migration file do:
  # rails g migration <name-of-migration>
  # ex. rails g migration add_view_count_to_questions view_count:integer
  def change
    # Use the add_column method to add colums to
    # a table. It's arguments are in order:
    # - table name as symbol
    # - new colum's name as a symbol
    # - the type of the new column
    add_column :questions, :view_count, :integer
  end
end
