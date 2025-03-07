class CreatePeople < ActiveRecord::Migration[8.0]
  def change
    add_column :people, :username, :string, null: false
    add_column :people, :firstname, :string, null: false
    add_column :people, :lastname, :string, null: false
    add_column :people, :phone_number, :string, null: false
    add_column :people, :role, :integer, null: false
    add_column :people, :iban, :string
    add_reference :people, :address, null: false, foreign_key: true
  end
end
