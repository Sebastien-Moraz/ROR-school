class SchoolClass < ApplicationRecord
  belongs_to :person  # Responsable de la classe
  belongs_to :room
  belongs_to :moment
  
  has_many :courses
  has_and_belongs_to_many :students, class_name: 'Person', join_table: 'people_school_classes'  # Étudiants dans la classe
end
