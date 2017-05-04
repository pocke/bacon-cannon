class Parmlink < ApplicationRecord
  has_many :parse_result_errors
  has_many :parse_results
end
