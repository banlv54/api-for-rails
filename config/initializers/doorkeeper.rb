Doorkeeper.configure do
  # Change the ORM that doorkeeper will use (needs plugins)
  orm :active_record

  resource_owner_from_credentials do
    binding.pry
    User.authenticate(params[:email], params[:password])
  end
end
Doorkeeper.configuration.token_grant_types << "password"
