class Job < ApplicationRecord
  scope :status, -> (status) { where status: status }
  #scope :created_at, -> (created_at) { where("created_at between ?", "#{name}%")}
end
