class Moment < ApplicationRecord
  has_many :school_classes
  has_many :courses
  
  enum :category, { 
    trimester_1: 0,  # Premier trimestre (Septembre - Décembre)
    trimester_2: 1,  # Deuxième trimestre (Janvier - Mars)
    trimester_3: 2,  # Troisième trimestre (Avril - Juin)
    trimester_4: 3   # Quatrième trimestre (Juillet - Août)
  }
end
