# frozen_string_literal: true

# == Schema Information
#
# Table name: chats
#
#  id          :bigint           not null, primary key
#  title       :string           not null
#  description :string
#  user_id     :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Chat < ApplicationRecord
  belongs_to :user
  has_many :messages, dependent: :destroy
  has_many :chat_members, dependent: :destroy
  has_many :users, through: :chat_members

  MEMBERS_LIMIT = 20_000

  has_one_attached :cover
  has_many :latest_messages,
           -> { Message.latest_for_chats }, class_name: "Message"

  attr_writer :members_count

  def members_readable
    if @members_count == 1
      "#{@members_count} Member"
    else
      "#{@members_count} Members"
    end
  end

  def created
    "Created " + created_at.strftime("%b %d , %Y")
  end

  def to_s
    title.truncate(15)
  end
end
