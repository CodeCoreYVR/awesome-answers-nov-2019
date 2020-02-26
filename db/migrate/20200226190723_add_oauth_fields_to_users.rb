class AddOauthFieldsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :uid, :string
    add_column :users, :provider, :string
    add_column :users, :oauth_token, :string 
    add_column :users, :oauth_raw_data, :string 
    add_index :users, [:uid, :provider]
  end
end
