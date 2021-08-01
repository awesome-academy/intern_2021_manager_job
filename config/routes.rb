Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    resources :accounts, only: %i(new create)
    resources :users, except: %i(index destroy)
    resources :companies, except: %i(index destroy)
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    resources :jobs
  end
end
