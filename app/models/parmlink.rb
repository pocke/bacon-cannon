# == Schema Information
#
# Table name: parmlinks
#
#  id         :integer          not null, primary key
#  uuid       :string           not null
#  code       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Parmlink < ApplicationRecord
  has_many :parse_result_errors
  has_many :parse_results
end
