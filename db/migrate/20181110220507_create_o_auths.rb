class CreateOAuths < ActiveRecord::Migration[5.2]
  def change
    drop_table(:o_auths , if_exists: true)
    create_table :o_auths do |t|

      t.timestamps
    end
  end
end
