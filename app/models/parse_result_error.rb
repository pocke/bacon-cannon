# == Schema Information
#
# Table name: parse_result_errors
#
#  id            :integer          not null, primary key
#  parmlink_id   :integer          not null
#  parser        :string           not null
#  error_class   :string           not null
#  error_message :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_parse_result_errors_on_parmlink_id  (parmlink_id)
#

class ParseResultError < ApplicationRecord
  belongs_to :parmlink
end
