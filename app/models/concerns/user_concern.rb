# frozen_string_literal: true

module UserConcern
  extend ActiveSupport::Concern

  included do
    enum GENDER = { Female: 0, Male: 1 }.freeze

    # add if needed
    enum MARTIAL_STATUS = { Single: 0, Divorced: 1, Separated: 2, 'In Relationship': 3 }.freeze
  
    # extend FriendlyId
    # friendly_id :full_name, use: :slugged

    acts_as_voter

    with_options dependent: :destroy do |assoc|
      assoc.has_one_attached :profile
      assoc.has_one_attached :cover_picture

      assoc.has_many :active_friendships, class_name: "Follow", foreign_key: :follower_id
      assoc.has_many :passive_friendships, class_name: "Follow", foreign_key: :followed_id

      assoc.has_many :posts
      assoc.has_many :owned_chats, class_name: "Chat" # as owner
      assoc.has_many :chat_members
      assoc.has_many :unwanted_users
    end
    has_many :followings, through: :active_friendships, source: :followed
    has_many :followers, through: :passive_friendships, source: :follower

    has_many :messages, dependent: :nullify
    has_many :chats, through: :chat_members

    # Validations
    validates :first_name, presence: true
    validates :gender, presence: true,
                       numericality: { only_integer: true },
                       inclusion: { in: GENDER.values }
    validates :martial_status, numericality: { only_integer: true },
                               inclusion: { in: MARTIAL_STATUS.values },
                               if: -> { martial_status.present? }
    validates :cover_picture, :profile, processable_image: true,
                              content_type: %i[png jpg jpeg webp],
                              size: { less_than: 2.megabytes, message: "is too large" },
                              if: -> { cover_picture.attached? }
  end

  # methods
  def full_name
    if last_name.present?
      "#{first_name} #{last_name}"
    else
      first_name
    end
  end

  def to_s
    full_name
  end

  def online?
    !!(last_seen_at&.> 3.minutes.ago)
  end

  def follow(user)
    active_friendships.create!(followed_id: user.id)
  end

  def unfollow(user)
    active_friendships.destroy_by(followed_id: user.id)
  end

  def follows?(user)
    active_friendships.exists?(followed_id: user.id)
  end

  def country_name
    _country = ISO3166::Country[country]
    # _country&.common_name
    if country
      _country.translations[I18n.locale.to_s] || country.common_name || country.iso_short_name
    end
  end

  def male?
    gender == 1
  end

  def last_profile
    if profile.attached?
      profile
    else
      "#{gender_str}.png"
    end
  end

  def gender_str
    GENDER.key(gender).to_s.downcase
  end

  def status
    MARTIAL_STATUS.key(martial_status).to_s
  end
end
