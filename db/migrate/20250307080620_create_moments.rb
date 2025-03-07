class CreateMoments < ActiveRecord::Migration[8.0]
  def change
    create_table :moments do |t|
      t.string :uid, null: false
      t.integer :category, null: false
      t.datetime :start_at, null: false
      t.datetime :end_at, null: false

      t.timestamps
    end
  end
end
