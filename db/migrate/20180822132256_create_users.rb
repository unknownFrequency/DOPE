class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    drop_table(:users, if_exists: true)
    create_table :users do |t|
      t.string :client_id
      t.string :client_secret
      t.string :api_key
      t.string :email

      t.timestamps
    end
  end
end
