# frozen_string_literal: true

class BlockedUserController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[create destroy]

  # GET /blocked_users
  def index
    @users = current_user.unwanted_users.where(blocked: true)
  end

  # POST /users/:id/block
  def create
    current_user.unfollow(@user)
    current_user.unwanted_users.where(unwanted_user_id: @user.id).first_or_create do |u|
      u.blocked = true
      u.save
    end

    redirect_to root_path
  end

  # DELETE /users/:id/unblock
  def destroy
    BlockedUser.destroy_by(user_id: current_user.id, blocked_user_id: @user.id)
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])

    raise_if_blank(@user, "User")
  end
end
