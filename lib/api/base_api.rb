class API::BaseAPI < Grape::API
  format :json
  content_type :json, "application/json;charset=utf-8"

    rescue_from Grape::Exceptions::ValidationErrors do |e|
    e = AlphaHC::Error::ParamInvalid.new e.message
    error_response(message: e.error_message, status: 200)
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    e = AlphaHC::Error::RecordNotFound.new
    error_response(message: e.error_message, status: 200)
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    e = AlphaHC::Error::RecordInvalid.new(
          e.record.errors.full_messages.join("\n"))
    error_response(message: e.error_message, status: 200)
  end

  rescue_from AlphaHC::Error::Base do |e|
    error_response(message: e.error_message, status: 200)
  end

  rescue_from :all do |e|
    if Rails.env.development? || Rails.env.test?
      raise e
    else
      # alway return Unknown errors with other error
      e = AlphaHC::Error::Unknown.new
      error_response(message: e.error_message, status: 200)
    end
  end

  helpers do
    def permit_model_params attributes
      ActionController::Parameters.new(params).permit attributes
    end

    def require_app_secret!
      unless request.headers['X-App-Secret'] == 'Ct-7_CEqO37l-3ViExTZsg'
        error! '401 Unauthorized', 401
      end
    end
  end

  before do
    require_app_secret!
    I18n.locale = headers[:locale] || Settings.locale.default
  end

  mount API::V1::BaseAPI
  mount API::V1::BaseAuthenticateAPI
end
