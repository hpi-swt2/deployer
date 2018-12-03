class Deployment < ApplicationRecord
  scope :successful, -> { where(success: true) }
end
