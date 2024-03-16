require "rails_helper"

RSpec.describe "Tops", type: :request do
  describe "トップページ正常なレスポンスを返すこと" do
    it "responds successfully" do
      get root_path
      expect(response).to be_successful
      expect(response).to have_http_status(:ok)
    end
  end
end
