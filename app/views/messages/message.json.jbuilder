# frozen_string_literal: true

json.okay true
json.action action

json.partial! "messages/message", locals: { message: message, user: user }