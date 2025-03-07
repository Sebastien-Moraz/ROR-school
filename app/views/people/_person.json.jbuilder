json.extract! person, :id, :username, :firstname, :lastname, :email, :phone_number, :role, :iban, :address_id, :created_at, :updated_at
json.url person_url(person, format: :json)
