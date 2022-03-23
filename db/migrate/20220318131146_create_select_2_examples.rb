class CreateSelect2Examples < ActiveRecord::Migration[6.1]
  def change
    create_table :select2_examples do |t|
      t.string :name
      t.string :example_type
      t.text :description

      t.timestamps
    end
  end
end
