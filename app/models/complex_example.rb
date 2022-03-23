class ComplexExample < ApplicationRecord
  attr_accessor :active_admin_amount

  enum example_types: {
    no_description: 'no_description',
    with_description: 'with_description'
  }
end

# == Schema Information
#
# Table name: complex_examples
#
#  id           :bigint(8)        not null, primary key
#  rut          :string
#  amount       :integer
#  name         :string
#  example_type :string
#  description  :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
