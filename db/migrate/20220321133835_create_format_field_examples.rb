class CreateFormatFieldExamples < ActiveRecord::Migration[6.1]
  def change
    create_table :format_field_examples do |t|
      t.string :rut
      t.integer :amount

      t.timestamps
    end
  end
end
