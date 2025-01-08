require 'rails_helper'

RSpec.describe "MCourses", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/m_courses/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/m_courses/new"
      expect(response).to have_http_status(:success)
    end
  end

end
