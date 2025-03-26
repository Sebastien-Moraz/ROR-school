class FixCourseSchoolClassAssociationAgain < ActiveRecord::Migration[8.0]
  def change
    # Supprimer l'index et la clé étrangère existants
    remove_index :courses, :classe_id if index_exists?(:courses, :classe_id)
    remove_foreign_key :courses, :classes if foreign_key_exists?(:courses, :classes)
    
    # Renommer la colonne
    rename_column :courses, :classe_id, :school_class_id
    
    # Ajouter le nouvel index et la nouvelle clé étrangère
    add_index :courses, :school_class_id unless index_exists?(:courses, :school_class_id)
    add_foreign_key :courses, :school_classes unless foreign_key_exists?(:courses, :school_classes)
  end
end
