module API::Entities::Faqs
  class Index < API::Entities::BaseEntity
    expose :id
    expose :question, format_with: :string
    expose :answer, format_with: :string
  end
end
