class CreateGifts < ActiveRecord::Migration[6.0]
  def change
    create_table :gifts do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.float :amount
      t.string :txn_id

      t.timestamps
    end
  end
end
