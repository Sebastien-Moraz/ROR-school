class Examination < ApplicationRecord
  belongs_to :course
  has_many :grades, dependent: :destroy

  before_destroy :check_for_grades

  private

  def check_for_grades
    if grades.any?
      errors.add(:base, "Impossible de supprimer cet examen car il contient des notes. Veuillez d'abord supprimer toutes les notes associées.")
      throw :abort
    end
  end
end
