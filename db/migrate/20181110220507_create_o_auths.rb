class CreateOAuths < ActiveRecord::Migration[5.2]
  def change
    create_table :o_auths do |t|

      t.timestamps
    end
  end
end
