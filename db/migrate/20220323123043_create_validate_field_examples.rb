class CreateValidateFieldExamples < ActiveRecord::Migration[6.1]
  def change
    create_table :validate_field_examples do |t|
      t.string :rut

      t.timestamps
    end
  end
end
