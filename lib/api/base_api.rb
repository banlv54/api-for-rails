class API::BaseAPI < Grape::API
  format :json
  content_type :json, "application/json;charset=utf-8"

  mount API::V1::BaseAPI
  mount API::V1::BaseAuthenticateAPI
end
