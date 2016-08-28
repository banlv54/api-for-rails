require "rails_helper"

describe API::V1::FaqsAPI, type: :request do
  let(:json) {JSON.parse(response.body)}

  describe "GET /api/v1/faqs", autodoc: true do
    let(:path) { "/api/v1/faqs" }

    let(:description) { "Get list faq" }

    before do
      2.times do |n|
        Faq.create question: "question #{n}", answer: "answer #{n}"
      end

      get(path, {}, "CONTENT_TYPE" => "application/json")
    end

    it { expect(json["faqs"].count).to eq 2 }
  end
end
