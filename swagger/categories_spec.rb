# swagger/categories_spec.rb
require 'swagger_helper'

RSpec.describe 'Categories API', type: :request do

  # GET /categories
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

  # GET /categories/{id}
  path '/categories/{id}' do
    get 'Retrieves a specific category' do
      tags 'Categories'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, description: 'Category ID'

      response '200', 'Category found' do
        schema '$ref' => '#/components/schemas/category'

        run_test!
      end

      response '404', 'Category not found' do
        run_test!
      end
    end
  end

  # POST /categories
  path '/categories' do
    post 'Creates a new category' do
      tags 'Categories'
      consumes 'application/json'
      parameter name: :category, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          icon: { type: :string },
          type: { type: :string, enum: ['category', 'subcategory'] },
          parent_category_id: { type: :integer }
        },
        required: ['title', 'type']
      }

      response '201', 'Category created' do
        schema '$ref' => '#/components/schemas/category'

        run_test!
      end

      response '422', 'Invalid parameters' do
        run_test!
      end
    end
  end

  # PUT /categories/{id}
  path '/categories/{id}' do
    put 'Updates an existing category' do
      tags 'Categories'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer, description: 'Category ID'
      parameter name: :category, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          icon: { type: :string },
          type: { type: :string, enum: ['category', 'subcategory'] },
          parent_category_id: { type: :integer }
        }
      }

      response '200', 'Category updated' do
        schema '$ref' => '#/components/schemas/category'

        run_test!
      end

      response '404', 'Category not found' do
        run_test!
      end

      response '422', 'Invalid parameters' do
        run_test!
      end
    end
  end

  # DELETE /categories/{id}
  path '/categories/{id}' do
    delete 'Deletes an existing category' do
      tags 'Categories'
      parameter name: :id, in: :path, type: :integer, description: 'Category ID'

      response '204', 'Category deleted' do
        run_test!
      end

      response '404', 'Category not found' do
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
