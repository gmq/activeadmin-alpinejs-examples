class Select2Example < ApplicationRecord
  enum example_types: {
    no_description: 'no_description',
    with_description: 'with_description'
  }
end

# == Schema Information
#
# Table name: select2_examples
#
#  id           :bigint(8)        not null, primary key
#  name         :string
#  example_type :string
#  description  :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
