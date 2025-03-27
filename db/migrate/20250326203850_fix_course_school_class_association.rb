class FixCourseSchoolClassAssociation < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :courses, :school_classes, column: :classe_id if foreign_key_exists?(:courses, :school_classes, column: :classe_id)
    rename_column :courses, :classe_id, :school_class_id if column_exists?(:courses, :classe_id)
    add_foreign_key :courses, :school_classes unless foreign_key_exists?(:courses, :school_classes)
  end
end
