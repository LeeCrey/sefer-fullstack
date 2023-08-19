# frozen_string_literal: true

# == Schema Information
#
# Table name: jwt_deny_lists
#
#  id         :bigint           not null, primary key
#  jti        :string           not null
#  exp        :datetime         not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class JwtDenyList < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Denylist

  # Validations
  validates :jti, :exp, presence: true
end
