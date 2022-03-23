class FormatFieldExample < ApplicationRecord
  attr_accessor :active_admin_amount
end

# == Schema Information
#
# Table name: format_fields
#
#  id         :bigint(8)        not null, primary key
#  rut        :string
#  amount     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
