# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def show?
    !blocked?
  end

  def followings?
    !blocked?
  end

  def followers?
    !blocked?
  end

  # since calling it follow controller
  def blocked?
    return false if @user.id == @record.id

    blocked = UnwantedUser.exists?(user_id: @user.id, unwanted_user_id: @record.id, blocked: true)
    if !blocked
      blocked = UnwantedUser.exists?(user_id: @record.id, unwanted_user_id: @user.id, blocked: true)
    end
    blocked
  end
end
