class CreateOAuth < ActiveRecord::Migration[5.2]
  def change
    create_table :o_auths do |t|
      t.string :token
      t.references :user, index:true
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
