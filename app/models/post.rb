# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id              :bigint           not null, primary key
#  content         :text
#  thread_id       :integer
#  user_id         :bigint           not null
#  comments_count  :integer          default(0), not null
#  cached_votes_up :integer          default(0), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  photos_count    :integer          not null
#
class Post < ApplicationRecord
  belongs_to :thread, class_name: "Post", foreign_key: :thread_id, optional: true
  has_many :comments, class_name: "Post", foreign_key: :thread_id, dependent: :nullify

  belongs_to :user
  has_many_attached :photos, dependent: :destroy
  acts_as_votable

  # Caching
  counter_culture :thread, column_name: :comments_count, touch: true

  attr_accessor :voted

  acts_as_votable cacheable_strategy: :update_columns

  # scopes
  scope :not_seen, ->(ids) do
          includes(user: :profile_attachment)
            .where(thread_id: nil).where(user: { id: ids })
          # .group(:user_id)
            .order(id: :desc)
        end

  def to_s
    content
  end
end
