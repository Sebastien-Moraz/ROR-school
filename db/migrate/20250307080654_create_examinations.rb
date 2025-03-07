class CreateExaminations < ActiveRecord::Migration[8.0]
  def change
    create_table :examinations do |t|
      t.string :title, null: false
      t.datetime :expected_at, null: false
      t.references :course, null: false, foreign_key: true

      t.timestamps
    end
  end
end
