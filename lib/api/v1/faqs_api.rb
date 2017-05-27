class API::V1::FaqsAPI < Grape::API
  resource :faqs do
    desc 'Return list faq and answer'

    get do
      present :faqs, Faq.all,
        with: API::V1::Entities::FaqsEntity::Index
    end
  end
end
