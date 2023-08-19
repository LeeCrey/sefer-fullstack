# frozen_string_literal: true

class ChatChannel < ApplicationCable::Channel
  # rescue_from 'MyError', with: :deliver_error_message

  # private
  #   def deliver_error_message(e)
  #     broadcast_to(...)
  #   end
  def subscribed
    if params[:id]
      @chat = Chat.find_by(id: params[:id])
      stream_from "chat_#{@chat.id}_user_#{current_user.id}" # for load more
    end

    chats = current_user.chats
    chats.each { |chat| stream_from "chat_#{chat.id}" }
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
