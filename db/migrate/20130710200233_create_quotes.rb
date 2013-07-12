class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
  end
end
