class CreateHasManyExamples < ActiveRecord::Migration[6.1]
  def change
    create_table :has_many_examples do |t|
      t.string :name

      t.timestamps
    end
  end
end
