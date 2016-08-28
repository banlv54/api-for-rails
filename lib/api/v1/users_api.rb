class API::V1::UsersAPI < Grape::API
  resource :users do
    desc 'Return list faq and answer'

    get do
      present :users, User.all,
        with: API::Entities::Users::Index
    end

    desc 'Return info user'

    route_param :id do
      params do
        requires :id, type: Integer
      end

      get do
        present User.find(params[:id]), with: API::Entities::Users::Index
      end
    end
  end
end
