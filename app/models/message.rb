# frozen_string_literal: true

# == Schema Information
#
# Table name: messages
#
#  id         :bigint           not null, primary key
#  body       :text
#  chat_id    :bigint           not null
#  user_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Message < ApplicationRecord
  belongs_to :chat
  belongs_to :user

  def self.latest_for_chats
    ranked_messages = Message.select(<<-SQL)
    messages.*,
    dense_rank() OVER (
      PARTITION BY messages.chat_id
      ORDER BY messages.id DESC
    ) AS message_rank
    SQL

    from(ranked_messages, "messages").where("message_rank <= 1")
  end

  def to_s
    body.truncate(15)
  end

  def created
    created_at.strftime("%b %G")
  end

  def created_time
    created_at.strftime("%c")
  end
end
