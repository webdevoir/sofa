Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :questions do
    resources :answers do
      patch :best, on: :member
    end
  end
end
