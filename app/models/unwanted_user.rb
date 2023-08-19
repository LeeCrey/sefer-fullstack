# frozen_string_literal: true

# == Schema Information
#
# Table name: unwanted_users
#
#  id               :bigint           not null, primary key
#  blocked          :boolean          default(FALSE), not null
#  user_id          :bigint           not null
#  unwanted_user_id :integer
#
class UnwantedUser < ApplicationRecord
  belongs_to :user

  # Validations
  validates :unwanted_user_id, presence: true, uniqueness: { scope: :user_id }
end
