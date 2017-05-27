class User < ActiveRecord::Base
  authenticates_with_sorcery!

  mount_uploader :avatar, AvatarUploader

  attr_accessor :avatar, :avatar_cache, :remove_avatar, :password, :password_confirmation

  validates :password, length: { minimum: 3 }, if: -> { changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { changes[:crypted_password] }

  validates :email, uniqueness: true, allow_blank: true,
            format: { with: /\A([\w\.%\+\-]+)@([\w.\-]+\.+[\w]{2,})\z/ },
            length: {maximum: 255}

  rails_admin do
    list do
      field :phone_number
      field :email
    end

    edit do
      field :phone_number
      field :email
      field :avatar, :carrierwave
      field :password, :password
      field :password_confirmation, :password
    end
  end
end
