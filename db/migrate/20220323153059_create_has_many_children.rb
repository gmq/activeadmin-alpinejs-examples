class CreateHasManyChildren < ActiveRecord::Migration[6.1]
  def change
    create_table :has_many_children do |t|
      t.string :name
      t.boolean :main
      t.references :has_many_example

      t.timestamps
    end
  end
end
