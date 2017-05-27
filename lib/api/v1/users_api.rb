class API::V1::UsersAPI < Grape::API
  helpers do
    def create_params
      permit_model_params :device_id
    end

    def update_params
      permit_model_params :phone_number, :email, :name
    end
  end
  resource :users do
    desc 'Create user'

    params do
      requires :device_id, type: Integer
    end

    post do
      User.create(device_id: permit_model_params[:device_id])
    end

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
