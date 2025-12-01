Rails.application.routes.draw do
  # get "withdrawals/index"
  # get "withdrawals/new"
  # get "withdrawals/create"
  # get "withdrawals/show"
  # get "item_batches/create"
  # get "item_batches/destroy"
  # resources :items

  resources :items do
    resources :item_batches, only: [:create, :destroy]
    collection do
      get :reorder        # pantalla con lista para seleccionar
      post :reorder_summary  # procesa cantidades y muestra vista previa
      post :reorder_pdf   # genera el PDF final
    end
  end

  resources :deliveries, only: [:index, :show]
  resources :patient_deliveries, only: [:index, :show]

  resources :withdrawals, only: [:index, :new, :create, :show]

  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"

  # root to: "home#index"
  get "dashboard", to: "dashboard#index"
  root "dashboard#index"

  resources :providers


  resource :profile, only: [:edit, :update]

  authenticate :user do
    resources :patients
  end

  resources :internal_users
end
