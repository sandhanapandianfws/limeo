require 'sidekiq/web'

Rails.application.routes.draw do

  mount Rswag::Ui::Engine => '/api-docs'

  mount Sidekiq::Web => '/sidekiq'

  root to: 'home#index'

  get 'home/index'

  get 'about', to: 'home#about'

  # Elastic Search API
  get 'courses/search', to: 'courses#search'

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


  # Course Subscription
  get 'course_subscriptions/subscribe'
  get 'course_subscriptions/unsubscribe'
  get 'course_subscriptions/subscribers'

  # ExamsMVCController
  get 'exams/index'
  get 'exams/show'
  get 'exams/new'
  get 'exams/create'
  get 'exams/edit'
  get 'exams/update'
  # delete 'exams/destroy', to: 'exams#destroy'
  resources :exams

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  get '/register', to: 'sessions#register'
  post '/register', to: 'sessions#create_user'

  # API User Login, Register and VerifyEmail
  post 'users/login', to: 'users#login'
  post 'users/register', to: 'users#register'
  get '/users/verifyEmail', to: 'users#verify_email'

end