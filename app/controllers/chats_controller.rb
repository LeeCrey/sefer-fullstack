# frozen_string_literal: true

class ChatsController < ApplicationController
  include Pagy::Backend

  before_action :authenticate_user!
  before_action :set_chat, only: %i[show edit update destroy]

  # GET /chats or /chats.json
  def index
    @chats = current_user.chats.includes(:latest_messages, cover_attachment: :blob)

    render "frame_response" and return if turbo_frame_request?
  end

  # GET /chats/1 or /chats/1.json
  def show
    @chat.members_count = @chat.chat_members.count

    messages = @chat.messages.includes(user: :profile_attachment).order(id: :desc)
    @pagy, @messages = pagy_countless(messages, items: 20)
    @next_url = "/chats/#{@chat.id}/messages?page=#{@pagy.next}"
  end

  # GET /chats/new
  def new
    @chat = Chat.new
  end

  # GET /chats/1/edit
  def edit
  end

  # POST /chats or /chats.json
  def create
    @chat = Chat.new(chat_params)
    @chat.user_id = current_user.id

    respond_to do |format|
      if @chat.save
        # should also be member of the chat
        member = @chat.chat_members.new
        member.user_id = current_user.id
        member.save

        format.html { redirect_to chat_url(@chat), notice: "Chat was successfully created." }
        format.json { render :show, status: :created, location: @chat }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @chat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chats/1 or /chats/1.json
  def update
    respond_to do |format|
      if @chat.update(chat_params)
        format.html { redirect_to chat_url(@chat), notice: "Chat was successfully updated." }
        format.json { render :show, status: :ok, location: @chat }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @chat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chats/1 or /chats/1.json
  def destroy
    @chat.destroy

    respond_to do |format|
      format.html { redirect_to chats_url, notice: "Chat was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_chat
    @chat = Chat.find(params[:id])
  end

  def chat_params
    params.require(:chat).permit(:title, :description, :cover)
  end
end
