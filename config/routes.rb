Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  use_doorkeeper

  mount API::BaseAPI => "/api"
end
