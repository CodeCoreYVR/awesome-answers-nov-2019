class AddAasmStateToQuestions < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :aasm_state, :string
  end
end
