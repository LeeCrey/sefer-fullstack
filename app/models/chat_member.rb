# == Schema Information
#
# Table name: chat_members
#
#  id         :bigint           not null, primary key
#  chat_id    :bigint           not null
#  user_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ChatMember < ApplicationRecord
  belongs_to :chat
  belongs_to :user
end
