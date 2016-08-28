# for api don't need authenticate
class API::V1::BaseAPI < Grape::API
  version 'v1'

  mount API::V1::FaqsAPI
end
