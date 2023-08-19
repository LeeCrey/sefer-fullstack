# frozen_string_literal: true

class MessagesController < ApplicationController
  respond_to :html, :json
  protect_from_forgery with: :null_session

  rescue_from Pundit::NotAuthorizedError, with: -> { redirect_back chats_path }

  include Pagy::Backend

  before_action :authenticate_user!
  before_action :set_chat
  before_action :authorize_message, only: %i[destroy update]

  # GET chats/:chat_id/messages?page
  def index
    authorize @chat

    messages = @chat.messages.includes(user: :profile_attachment).order(id: :desc)
    @pagy, @messages = pagy(messages, items: 20)
    @next_url = pagy_url_for(@pagy, @pagy.next) unless turbo_frame_request?

    send_message_to_chat(@chat, @messages, @pagy)
  end

  # POST /chats/:chat_id/messages
  def create
    @message = @chat.messages.new(message_params)

    authorize @message

    @message.user_id = current_user.id

    if @message.save
      broadcast(@message, :append)
    else
    end

    head :no_content
    # event listening for turbo stream to clear after the message has been submited
  end

  # PATCH/PUT messages/:id
  def update
    if @message.update(message_params)
      respond_to do |format|
        format.turbo_stream do
          lokals = { message: @message, user: current_user }
          @message.broadcast_update_to(@message.chat, locals: lokals)
        end
        format.html { redirect_to @chat }
      end
    end
  end

  # DELETE messages/:id
  def destroy
    @message.destroy

    respond_to do |format|
      format.turbo_stream { @message.broadcast_remove_to(@message.chat) }
      format.html { redirect_to @chat, notice: "Message removed" }
    end
  end

  private

  def send_message_to_chat(chat, msgs, pagy)
    # render as string. Fix this
    lokals = { message: msgs, user: current_user, pagy: pagy_metadata(pagy) }
    msgs_json = render(:index, locals: lokals, formats: :json)

    ActionCable.server.broadcast("chat_#{chat.id}_user_#{current_user.id}", msgs_json)
  end

  def set_chat
    @chat = Chat.find_by(id: params[:chat_id])
  end

  def message_params
    params.require(:message).permit(:body)
  end

  def authorize_message
    authorize @message
  end

  def broadcast(msg, action)
    lokals = { message: msg, user: current_user, action: action }
    msg_json = render(:message, formats: :json, locals: lokals)
    ActionCable.server.broadcast("chat_#{msg.chat_id}", msg_json)
  end

  def user_profile
    if current_user.profile.attached?
      # current_user.profile.url # for AWS S3
      Rails.application.routes.url_helpers.rails_blob_url(current_user.profile)
    else
      # image_url("male.png")
      "/assets/male.png"
    end
  end
end
