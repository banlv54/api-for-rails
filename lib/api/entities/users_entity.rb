module API::Entities::UsersEntity
  class Index < API::Entities::BaseEntity
    expose :id
    expose :age, format_with: :integer
  end
end
