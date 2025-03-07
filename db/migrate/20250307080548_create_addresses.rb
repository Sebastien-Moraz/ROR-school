class CreateAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses do |t|
      t.string :zip, null: false
      t.string :town, null: false
      t.string :street, null: false
      t.string :number

      t.timestamps
    end
  end
end
