module API::Entities::Users
  class Index < API::Entities::BaseEntity
    expose :id
    expose :age, format_with: :integer
    expose :phone_number
    expose :email
    expose :avatar, format_with: :avatar
  end
end
