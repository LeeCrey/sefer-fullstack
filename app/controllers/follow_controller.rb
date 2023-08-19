# frozen_string_literal: true

class FollowController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user, only: %i[followers followings]
  before_action :set_user

  # GET /users/:id/followings
  def followings
    @users = @user.followings
  end

  # GET users/:id/followers
  def followers
    @users = @user.followers
  end

  # POST /users/:id/follow
  def follow
    if UserPolicy.new(current_user, @user).blocked?
      @follows = true # since in follow.html.erb uses its inverse
      render :follow and return
    end

    @follows = current_user.follows? @user
    if @follows
      current_user.unfollow @user
    else
      current_user.follow @user
    end
  end

  private

  def authorize_user
    authorize @user
  end

  def set_user
    @user = User.find_by(id: params[:id])

    raise_if_blank(@user, "User")
  end
end
