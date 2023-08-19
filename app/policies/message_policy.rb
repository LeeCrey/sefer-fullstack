# frozen_string_literal: true

class MessagePolicy < ApplicationPolicy
  def create?
    @user.chats.exists?(id: @record.chat_id)
  end

  def update?
    _check
  end

  def destroy?
    _check
  end

  private

  def _check
    @user.id == @record.user_id
  end
end
