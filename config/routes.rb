Rails.application.routes.draw do
  use_doorkeeper
  mount API::BaseAPI => "/api"

end
