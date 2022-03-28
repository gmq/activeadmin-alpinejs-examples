class HasManyChild < ApplicationRecord
  belongs_to :has_many_example
end

# == Schema Information
#
# Table name: has_many_children
#
#  id                  :bigint(8)        not null, primary key
#  name                :string
#  main                :boolean
#  has_many_example_id :bigint(8)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_has_many_children_on_has_many_example_id  (has_many_example_id)
#
