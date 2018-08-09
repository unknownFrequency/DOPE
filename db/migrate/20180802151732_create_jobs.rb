class CreateJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :jobs do |t|
      t.string :body
      t.boolean :status

      t.timestamps
    end
  end
end
