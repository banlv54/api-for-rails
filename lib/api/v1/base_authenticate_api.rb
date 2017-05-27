require 'doorkeeper/grape/helpers'

class API::V1::BaseAuthenticateAPI < Grape::API
  version 'v1'

  helpers Doorkeeper::Grape::Helpers

  before do
    doorkeeper_authorize!
  end

  mount API::V1::UsersAPI
end
