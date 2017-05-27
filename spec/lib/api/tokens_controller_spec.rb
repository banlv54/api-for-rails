require 'rails_helper'

describe 'TokensController', type: :request do
  let!(:user) { User.create device_id: SecureRandom.hex(12) }
  let!(:token) do
    Doorkeeper::AccessToken.create(resource_owner_id: user.id).token
  end
  let(:params) do
    {
      password: '',
      email: '',
      grant_type: 'password',
      device_id: user.device_id,
    }
  end
  let(:json) { JSON.parse(response.body) }

  describe "POST '/oauth/token'", autodoc: true do
    let(:path) { '/oauth/token' }

    context 'login' do
      let(:description) { 'Login api - alway set email and password ' }
      before { post path, params: params, headers: {'X-App-Secret' => 'Ct-7_CEqO37l-3ViExTZsg'} }
      it 'responds with 200 and body include key: access_token, token_type, created_at' do
        expect(response.status).to eq 200
        expect(json['access_token']).to be_an String
        expect(json['token_type']).to eq 'bearer'
        expect(json['created_at']).to be_an Integer
      end
    end
  end
end
