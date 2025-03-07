class Examination < ApplicationRecord
  belongs_to :course
  has_many :grades
end
