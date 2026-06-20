Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users

  root "posts#index"
  resources :posts, only: [:index, :new, :create] do
    resources :likes, only: [:create]
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
