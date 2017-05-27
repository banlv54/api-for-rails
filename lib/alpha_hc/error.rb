module AlphaHC::Error
  extend ActiveSupport::Autoload
  CODES = {
    invalid_token: 601,
    api_common_unknown: 'unknown',
    api_common_param_invalid: 'param_invalid',
    api_common_record_not_found: 'record_not_found',
    api_common_login_failed: 'login_failed',
    api_common_refresh_token_failed: 'refresh_token_failed',
    api_common_record_invalid: 'record_invalid',
  }.freeze

  class Base < ::StandardError
    STATUS = 200

    attr_reader :code, :status

    def initialize *args
      underscore_name = self.class.name.underscore
      key = underscore_name.gsub('kids_taxi/error/', '').gsub(/\//, '_').to_sym
      @code = AlphaHC::Error::CODES[key]
      @status = self.class::STATUS

      if args.length.zero?
        t_key = underscore_name.gsub /\//, '.'
        super I18n.t(t_key)
      else
        super *args
      end
    end

    def error_message
      {
        error: {
          code: code,
          message: message,
          status: status
        }
      }
    end
  end

  class Unknown < AlphaHC::Error::Base
  end

  class ParamInvalid < AlphaHC::Error::Base
  end

  class RecordInvalid < AlphaHC::Error::Base
  end

  class RecordNotFound < AlphaHC::Error::Base
  end

  class LoginFailed < AlphaHC::Error::Base
  end

  class RefreshTokenFailed < AlphaHC::Error::Base
  end
end
