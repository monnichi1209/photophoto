Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  resources :contacts
  resources :feeds
  resources :sessions, only: [:new, :create, :destroy]
  resources :users, only: [:new, :create, :show, :edit, :update] do
    get :favorites, on: :member
  end
  resources :pictures do
    collection do
      post :confirm
    end
    resources :favorites, only: [:create, :destroy]
    end
  
end
