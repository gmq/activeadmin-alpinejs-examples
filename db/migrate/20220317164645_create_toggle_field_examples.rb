class CreateToggleFieldExamples < ActiveRecord::Migration[6.1]
  def change
    create_table :toggle_field_examples do |t|
      t.string :name
      t.boolean :has_description
      t.text :description

      t.timestamps
    end
  end
end
