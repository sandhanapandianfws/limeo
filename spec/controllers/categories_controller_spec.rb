# require 'spec_helper'
require 'rails_helper'
require 'factory_bot_rails'


RSpec.describe CategoriesController, type: :controller do

  let!(:categories) { create_list(:category, 3, :with_subcategories) }

  before do
    allow(controller).to receive(:authenticate_request).and_return(true)
  end

  describe "GET #index" do
    it "returns a successful response" do
      get :index

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      p json_response
      # Check the structure of the response
      expect(json_response).to be_an(Array)
      expect(json_response.size).to gt(0)

      # Check for included subcategories
      json_response.each do |category|
        expect(category).to include('subcategories')
      end
    end
  end


  describe "GET #show" do
    let!(:category) { create(:category, :with_subcategories) } # FactoryBot category with subcategories

    context "when the category exists" do
      before do
        get :show, params: { id: category.id }
      end

      it "returns a successful response" do
        expect(response).to have_http_status(:ok)
      end

      it "renders the category with subcategories in the JSON response" do
        json_response = JSON.parse(response.body)
        expect(json_response["id"]).to eq(category.id)
        expect(json_response["subcategories"].size).to eq(category.subcategories.size)
      end
    end

    context "when the category does not exist" do
      before do
        get :show, params: { id: 99999 } # ID that doesn't exist
      end

      it "returns a not found status" do
        expect(response).to have_http_status(:not_found)
      end

      it "returns an error message in the JSON response" do
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("Category not found")
      end
    end
  end

  describe "POST #create" do
    let(:valid_attributes) do
      {
        category: {
          title: "New Category",
          type: :category,
          icon: "icon.png",
          parent_category_id: nil
        }
      }
    end

    let(:invalid_attributes) do
      {
        category: {
          title: "",
          type: :category
        }
      }
    end

    context "with valid parameters" do
      it "creates a new category" do
        expect {
          post :create, params: valid_attributes
        }.to change(Category, :count).by(1)
      end

      it "returns a created status" do
        post :create, params: valid_attributes
        expect(response).to have_http_status(:created)
      end

      it "returns the created category in the response" do
        post :create, params: valid_attributes
        json_response = JSON.parse(response.body)
        expect(json_response["title"]).to eq(valid_attributes[:category][:title])
        expect(json_response["type"]).to eq(valid_attributes[:category][:type].to_s)
      end
    end

    context "with invalid parameters" do
      it "does not create a new category" do
        expect {
          post :create, params: invalid_attributes
        }.not_to change(Category, :count)
      end

      it "returns an unprocessable entity status" do
        post :create, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns validation errors in the response" do
        post :create, params: invalid_attributes
        json_response = JSON.parse(response.body)
        expect(json_response["errors"]).to include("Title can't be blank")
      end
    end
  end


  describe "DELETE #destroy" do
    let(:valid_attributes) do
      {
        category: {
          title: "New Category",
          type: :category,
          icon: "icon.png",
          parent_category_id: nil
        }
      }
    end
    let!(:category) { create(:category) }

    context "when the category exists" do
      it "deletes the category and returns no content" do
        expect {
          delete :destroy, params: { id: category.id }
        }.to change(Category, :count).by(-1)

        expect(response).to have_http_status(:no_content)
      end
    end

    context "when the category does not exist" do
      it "returns a not found error" do
        delete :destroy, params: { id: 9999 }

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Category not found' })
      end
    end
  end

end
