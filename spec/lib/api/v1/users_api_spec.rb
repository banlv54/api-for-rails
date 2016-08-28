require "rails_helper"

describe API::V1::UsersAPI, type: :request do
  let(:json) {JSON.parse(response.body)}
  let(:user) { User.create email: "email@gmail.com"}
  let(:access_token) { Doorkeeper::AccessToken.create(resource_owner_id: user.id).token }

  describe "GET /api/v1/users" do
    let(:path) { "/api/v1/users" }

    context "authorize", autodoc: true do
      let(:description) { "Get list user with authorize" }

      before do
        2.times do |n|
          User.create email: "email-#{n}@gmail.com", age: n
        end

        get(path, {}, "CONTENT_TYPE" => "application/json",
            "Authorization" => "Bearer #{access_token}")
      end

      it { expect(json["users"].count).to eq 3 }
    end

    context "unauthorize" do
      let(:description) { "Get list user unauthorize" }

      before do
        2.times do |n|
          User.create email: "email-#{n}@gmail.com", age: n
        end

        get(path, {}, "CONTENT_TYPE" => "application/json",
            "Authorization" => "Bearer xxx")
      end

      it { expect(json["error"]).to eq "The access token is invalid" }
    end
  end
end
