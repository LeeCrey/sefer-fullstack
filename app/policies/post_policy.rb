# frozen_string_literal: true

class PostPolicy < ApplicationPolicy
  def destroy?
    is_user = @record.user_id == @user.id
    if @record.thread_id
      # post owner can delete comment
      is_thread_owner = @record.thread.user_id == @user.id
      return is_user || is_thread_owner
    end
    is_user
  end

  def update?
    _check
  end

  def edit?
    _check
  end

  private

  def _check
    @record.user_id == @user.id
  end
end
