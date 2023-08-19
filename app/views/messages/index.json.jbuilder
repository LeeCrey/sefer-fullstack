# frozen_string_literal: true

json.okay true
json.action :prepend
json.messages do
  json.partial! "messages/message", collection: @messages, as: :message
end

json.pagy do
  json.extract! pagy, :page, :next, :page, :next_url, :prev_url
end
