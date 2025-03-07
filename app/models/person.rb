class Person < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  belongs_to :address
  has_many :managed_classes, class_name: 'SchoolClass', foreign_key: 'person_id'  # Classes dont la personne est responsable
  has_many :courses  # Cours enseignés par la personne
  has_many :grades  # Notes reçues par la personne
  has_and_belongs_to_many :enrolled_classes, class_name: 'SchoolClass', join_table: 'people_school_classes'  # Classes auxquelles la personne participe
  
  enum :role, { student: 0, teacher: 1, admin: 2 }
end
