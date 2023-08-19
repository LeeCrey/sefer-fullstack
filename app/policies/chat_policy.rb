# frozen_string_literal: true

class ChatPolicy < ApplicationPolicy
  def index?
    ChatMember.exists?(chat_id: @record.id, user_id: @user.id)
  end
end
