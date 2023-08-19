# frozen_string_literal: true

json.message do
  json.extract! message, :id, :body, :chat_id
  json.created_at message.created_at.strftime("%c")
end

json.user do
  json.extract! message.user, :full_name, :id
  if message.user.profile.attached?
    # Rails.application.routes.url_helpers.
    rails_blob_url(message.user.profile)
  else
    # fix this. use url_for
    json.profile "/assets/#{message.user.gender_str}.png"
  end
end
