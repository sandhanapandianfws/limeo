require 'sidekiq/web'

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'

  mount Sidekiq::Web => '/sidekiq'

  resources :articles
  resources :courses
  resources :courses do
    resources :sections
  end
  resources :categories

  post 'users/login', to: 'users#login'

  post 'users/register', to: 'users#register'

  get '/users/verifyEmail', to: 'users#verify_email'

end