require 'rails_helper'

RSpec.describe "CourseSubscriptions", type: :request do
  describe "GET /subscribe" do
    it "returns http success" do
      get "/course_subscriptions/subscribe"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /unsubscribe" do
    it "returns http success" do
      get "/course_subscriptions/unsubscribe"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /subscribers" do
    it "returns http success" do
      get "/course_subscriptions/subscribers"
      expect(response).to have_http_status(:success)
    end
  end

end
