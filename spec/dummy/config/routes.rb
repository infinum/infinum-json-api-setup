Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :locations, only: [:index, :create, :show, :update, :destroy]
      resources :hello, only: [:index]
    end
  end
end
