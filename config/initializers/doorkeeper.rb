Doorkeeper.configure do
  # Change the ORM that doorkeeper will use (needs plugins)
  orm :active_record

  access_token_expires_in nil

  resource_owner_from_credentials do
    # User.authenticate(params[:phone_number], params[:password])
    User.find_by(device_id: params[:device_id])
  end
end
Doorkeeper.configuration.token_grant_types << "password"
