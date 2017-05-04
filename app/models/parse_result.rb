# == Schema Information
#
# Table name: parse_results
#
#  id          :integer          not null, primary key
#  parmlink_id :integer          not null
#  ast         :text             not null
#  parser      :string           not null
#  meta        :json             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_parse_results_on_parmlink_id  (parmlink_id)
#

class ParseResult < ApplicationRecord
  belongs_to :parmlink
end
