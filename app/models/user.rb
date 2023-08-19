# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  first_name             :string           not null
#  last_name              :string
#  country                :string
#  martial_status         :integer
#  last_seen_at           :datetime
#  biography              :string
#  gender                 :integer          not null
#  verified               :boolean          default(FALSE), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#
class User < ApplicationRecord
  # :timeoutable, :trackable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :omniauthable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JwtDenyList

  encrypts :first_name, :last_name, deterministic: true
  # encrypts :email, deterministic: true # exception?

  # Scopes
  scope :not_following, ->(exclude_ids) do
          with_attached_profile.where.not(id: exclude_ids)
        end

  include UserConcern

  attr_accessor :follows, :followers_count, :followings_count, :posts_count, :profile_url
end
