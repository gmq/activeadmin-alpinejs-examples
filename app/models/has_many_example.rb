class HasManyExample < ApplicationRecord
  has_many :has_many_children
  accepts_nested_attributes_for :has_many_children, allow_destroy: true
end

# == Schema Information
#
# Table name: has_many_examples
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
