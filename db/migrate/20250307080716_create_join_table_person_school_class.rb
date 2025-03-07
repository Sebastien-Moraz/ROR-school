class CreateJoinTablePersonSchoolClass < ActiveRecord::Migration[8.0]
  def change
    create_join_table :people, :school_classes do |t|
      # t.index [:person_id, :school_class_id]
      # t.index [:school_class_id, :person_id]
    end
  end
end
