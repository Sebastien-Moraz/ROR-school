class Address < ApplicationRecord
  has_many :people
  
  def full_address
    "#{number} #{street}, #{zip} #{town}"
  end
end
