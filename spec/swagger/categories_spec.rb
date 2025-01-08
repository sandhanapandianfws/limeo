# spec/swagger/categories_spec.rb
require 'swagger_helper'

RSpec.describe 'Categories API', type: :request do
  path '/categories' do
    get 'Retrieves all categories' do
      tags 'Categories'
      produces 'application/json'

      response '200', 'Categories found' do
        schema type: :array,
               items: { '$ref' => '#/components/schemas/category' }

        run_test!
      end
    end
  end

  components do
    schema 'category' do
      key :type, :object
      key :properties, {
        id: { type: :integer },
        title: { type: :string },
        icon: { type: :string },
        type: { type: :string, enum: ['category', 'subcategory'] },
        parent_category_id: { type: :integer }
      }
    end
  end
end
