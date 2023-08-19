# frozen_string_literal: true

class PostsController < ApplicationController
  include Pagy::Backend

  before_action :authenticate_user!
  before_action :set_post, only: %i[show edit update destroy vote]

  # GET v1/posts
  def index
    if params[:thread_id]
      render_comments
    else
      following_ids = current_user.following_ids
      _posts = Post.not_seen(following_ids)
      _pagy, posts = pagy(_posts, items: 20)
      @meta = pagy_metadata(_pagy)
      voted_ids = Vote.voted_post_ids(current_user, nil)
      @posts = posts.map { |post| post.voted = (voted_ids.include? post.id); post }
  
      render :posts and return if turbo_frame_request?
    end
  end

  # GET /posts/new
  def new
    @post = Post.new

    @method = :post
  end

  # GET /posts/:id
  def show
    @post.voted = current_user.voted_for? @post
  end

  # GET /posts/:id/edit
  def edit
    authorize @post

    @method = :patch

    render :new
  end

  def create
    @post = current_user.posts.new(post_params)
    @post.photos_count = 0

    if @post.save
      if @post.thread_id.present?
        lokals = { current_user: current_user, post: @post }
        @post.broadcast_prepend_to(@post.thread, locals: lokals)
        # redirect_to @post.thread, notice: "Comment was successfully submitted."
      else
        redirect_to @post, notice: "Post was successfully created."
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /posts/:id
  def update
    authorize @post

    if @post.update(post_update_params)
      redirect_to @post, notice: "Post was successfully updated."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /posts/:id
  def destroy
    authorize @post

    @post.destroy

    if @post.thread_id?
      # stream replace
    else
      redirect_to current_user
      # head :no_content
    end
  end

  # POST /posts/:id/vote
  def vote
    voted = current_user.voted_for? @post
    if voted
      @post.unliked_by current_user
    else
      @post.liked_by current_user
    end
    @post.voted = !voted
  end

  private

  def set_post
    @post = Post.find_by(id: params[:id])

    raise_if_blank(@post, "Post")
  end

  def post_params
    thread_id = params[:thread_id]
    if thread_id.present?
      _params = params.require(:comment).permit(:content)
      _params[:thread_id] = thread_id
      return _params
    end
    params.require(:post).permit(:content)
  end

  def post_update_params
    params.require(:post).permit(:content)
  end

  def render_comments
    _comments = Post.includes(user: :profile_attachment).where(thread_id: params[:thread_id])
    @pagy, comments = pagy_countless(_comments, items: 2)
    # Narrow down
    voted_ids = Vote.voted_post_ids(current_user, params[:thread_id])
    @comments = comments.map { |post| post.voted = (voted_ids.include? post.id); post }

    @next_url = pagy_url_for(@pagy, @pagy.next)

    render :comments
  end
end
