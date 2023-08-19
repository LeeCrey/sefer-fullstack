# frozen_string_literal: true

class UsersController < ApplicationController
  include Pagy::Backend

  before_action :authenticate_user!
  before_action :set_user, only: %i[show hide]
  before_action :prepare_ids_to_exclude, only: %i[index]

  # GET /users
  def index
    users = User.not_following(@exclude_users)
    _limit = params[:limit].to_i # if it's nil.to_i => 0
    limit = if _limit <= 20 && _limit > 0
        _limit
      else
        20
      end
    @pagy, @users = pagy(users, items: limit)
    @next_url = pagy_url_for(@pagy, @pagy.next)
    @prev_url = pagy_url_for(@pagy, @pagy.prev)

    render "users/recommend" and return if turbo_frame_request?
  end

  # GET /users/:id
  def show
    authorize @user

    # No need to check if current user follows him/her(self)
    @user.follows = current_user.follows? @user if @user.id != current_user.id
    @user.followers_count = @user.followers.count
    @user.followings_count = @user.followings.count
    @user.posts_count = @user.posts.count
    posts = []
    if @user.profile.attached?
      posts = @user.posts.includes(:user, photos_attachments: :blob).limit(10)
    else
      posts = @user.posts.limit(10)
    end
    voted_posts_ids = Vote.voted_post_ids(current_user, nil)
    @posts = posts.map { |post| post.voted = voted_posts_ids.include?(post.id); post }
  end

  # users/:id/hide
  def hide
    current_user.unwanted_users.new(unwanted_user_id: @user.id).save
  end

  # GET /search
  def search
    if turbo_frame_request?
      filled = search_params.select { |_, v| v.present? }
      users = User.includes(:profile_attachment).where(filled)
      @pagy, @users = pagy(users, items: 20)
      @next_url = pagy_url_for(@pagy, @pagy.next)
      @prev_url = pagy_url_for(@pagy, @pagy.prev)

      render "users/search_result" and return
    end
  end

  # GET /online
  def online
    _limit = params[:limit] ||= 6
    @users = current_user.followings.includes(:profile_attachment).limit(_limit)
  end

  private

  def prepare_ids_to_exclude
    # following ids
    f_ids = current_user.following_ids
    ids = current_user.unwanted_users.pluck(:unwanted_user_id)
    @exclude_users = f_ids.including(current_user.id, ids)
  end

  def set_user
    @user = User.find_by(id: params[:id])

    raise_if_blank(@user, "User")
  end

  def search_params
    params.require(:user).permit(:first_name, :last_name, :gender)
  end
end
