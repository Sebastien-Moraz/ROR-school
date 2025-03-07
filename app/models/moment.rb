class Moment < ApplicationRecord
  has_many :school_classes
  has_many :courses
  
  enum :category, { morning: 0, afternoon: 1, evening: 2 }
end
