class CreateComplexExamples < ActiveRecord::Migration[6.1]
  def change
    create_table :complex_examples do |t|
      t.string :rut
      t.integer :amount
      t.string :name
      t.string :example_type
      t.string :description

      t.timestamps
    end
  end
end
