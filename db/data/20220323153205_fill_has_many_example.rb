# frozen_string_literal: true

class FillHasManyExample < ActiveRecord::Migration[6.1]
  def up
    has_many_example = FactoryBot.create(:has_many_example)
    FactoryBot.create_list(:has_many_child, 10, has_many_example: has_many_example)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
