require 'sidekiq/web'

Rails.application.routes.draw do
  get 'course_subscriptions/subscribe'
  get 'course_subscriptions/unsubscribe'
  get 'course_subscriptions/subscribers'
  mount Rswag::Ui::Engine => '/api-docs'

  mount Sidekiq::Web => '/sidekiq'

  resources :courses, only: [:show, :create, :update, :destroy] do
    member do
      post 'sections', to: 'courses#create_section'
      get 'sections', to: 'courses#get_sections'

      post 'subscribe', to: 'course_subscriptions#subscribe'
      delete 'unsubscribe', to: 'course_subscriptions#unsubscribe'
      get 'subscribers', to: 'course_subscriptions#subscribers'
    end

    resources :sections, only: [] do
      member do
        delete 'destroy', to: 'courses#destroy_section'
        post 'lectures', to: 'courses#create_lecture'
      end
    end

  end

  resources :categories

  post 'users/login', to: 'users#login'

  post 'users/register', to: 'users#register'

  get '/users/verifyEmail', to: 'users#verify_email'

end