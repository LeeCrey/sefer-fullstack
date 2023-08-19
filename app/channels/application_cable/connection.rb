# frozen_string_literal: true

# does handle API-only requests
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      # This is for other clients(android, ios, react.js, vue.js ...)
      # Authorization value can be both format
      # => Bearer TokenValue or TokenValue only
      authorization = request.params["Authorization"]

      current_user = if authorization.nil?
          get_from_cookie
        else
          token = authorization.split(" ").last
          decode_user(token)
        end

      if current_user
        current_user
      else
        reject_unauthorized_connection
      end
    end

    def get_from_cookie
      User.find_by(id: cookies.encrypted[:uid])
    end

    def decode_user(token)
      Warden::JWTAuth::UserDecoder.new.call(token, :user, nil) if token
    rescue JWT::DecodeError
      nil
    end
  end
end
