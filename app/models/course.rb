class Course < ApplicationRecord
  belongs_to :school_class
  belongs_to :subject
  belongs_to :moment
  belongs_to :person  # Enseignant du cours
  
  has_many :examinations
  
  enum :week_day, { monday: 0, tuesday: 1, wednesday: 2, thursday: 3, friday: 4, saturday: 5, sunday: 6 }
end
