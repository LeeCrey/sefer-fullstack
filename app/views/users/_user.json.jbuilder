# frozen_string_literal: true

json.user do
  json.extract! user, :full_name, :id
  if user.profile.attached?
  else
    json.profile image_tag user.last_profile
  end
end
