# frozen_string_literal: true

# == Schema Information
#
# Table name: follows
#
#  id          :bigint           not null, primary key
#  follower_id :integer          not null
#  followed_id :integer          not null
#
class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  MSG = "already following"

  # Validations
  validates :follower_id, :followed_id, presence: true
  ## unique constraint does the job but i need the message.
  validates :followed_id, uniqueness: { scope: :follower_id, message: MSG }
  ## User should not follow (him/her)self
  validates :follower_id, comparison: { other_than: :followed_id }
end
