Rails.application.routes.draw do
 
  get "profiles/edit"
  get "profiles/update"
  get "internal_users/index"
  get "internal_users/edit"
  get "internal_users/update"

  resources :clients, only: [:index, :new, :create, :edit, :update]
  resources :internal_users
  resource :profile, only: [:edit, :update]
  
  resources :stocks do
    member do
      delete 'delete_image/:image_id', to: 'stocks#delete_image', as: 'delete_image'
    end
  end

  resources :services
  resources :budgets do
    collection do
      get 'search_items' # Ruta para buscar productos y servicios
    end

    member do
      post 'send_email' # Ruta para enviar el presupuesto por mail
    end
  end
  resources :expenses
  
  devise_for :users, controllers: { registrations: 'users/registrations' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"

  get "dashboard", to: "dashboard#index"
  root "public#home"

  get "products", to: "public#products"
  get "carddetail", to: "public#services"

  
  get "contact", to: "public#contact"
  post 'send_contact', to: 'public#send_contact'

  get 'products/:id', to: 'public#product', as: :public_product

  get "exchange_rate/dolar", to: "exchange_rates#dolar"
end
