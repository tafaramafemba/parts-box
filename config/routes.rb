Rails.application.routes.draw do
  devise_for :admins, path: 'admins'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  devise_scope :user do
    get 'account/settings', to: 'users#edit', as: :edit_account_settings
  end
  
  get 'fault_codes/search', to: 'fault_codes#search', as: 'search_fault_codes'
  get 'car_parts/search', to: 'car_parts#search', as: 'search_car_parts'
  match 'orders/execute_paypal_payment', to: 'orders#execute_paypal_payment', via: [:get, :post], as: 'execute_paypal_payment'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # config/routes.rb
  mount ActionCable.server => '/cable'


  resources :products do
    collection do
      get :my_listings
    end
    member do
      patch :delist
      patch :relist
    end
  end

  get '/user_agreement', to: 'policies#user_agreement'
  get '/seller_policies', to: 'policies#seller_policies'
  get '/privacy_policy', to: 'policies#privacy_policy'
  get '/data_protection_policy', to: 'policies#data_protection_policy'
  get '/return_policy', to: 'policies#return_policy'

  resources :carts, only: [:index, :create, :destroy, :update]
  resources :orders, only: [:index, :new, :create, :show]
  post 'orders/:id/cancel', to: 'orders#cancel', as: 'cancel_order'
  resource :shipping_address, only: [:create, :update, :destroy]
  resources :seller_applications, only: [:new, :create, :show]
  post 'send_verification_code', to: 'seller_applications#send_verification_code'
  post 'verify_email', to: 'verifications#verify_email'

  resources :order_items do
    member do
      get 'return', to: 'order_items#return'
    end
  end


  namespace :admin do
    resources :seller_applications, only: [:index, :show, :update]
    resources :seller_informations, only: [:index, :show, :update]
    resources :orders, only: [:index, :show] do
      member do
        patch :update_status
      end
    end
    resources :delivery_slots
    resources :deliveries, only: [:index] do
      member do
        patch :mark_as_completed
        patch :mark_as_not_completed
      end
      collection do
        get :export_slot
      end
    end
  end



  
  resources :transactions, only: %i[create index]
  resources :trade_requests, only: %i[create destroy]
  resources :inbox, only: %i[index show destroy]
  resources :chats, only: [:index, :create, :show] do
    resources :messages, only: [:create]
  end
  
  post 'account/settings/shipping_address', to: 'shipping_addresses#create', as: 'user_shipping_address'

  post '/stripe/webhook', to: 'stripe_webhook#handle_event'

  namespace :users do
    resources :stripe_connects, only: [:new] do
      collection do
        post :create_account
        post :connect_existing_account
        post :disconnect_account
        get :callback
      end
    end

    resources :paypal_connects, only: [:new] do
      collection do
        post :create_account
        post :connect_existing_account
        get :callback
      end
    end
  end
  
  

  resources :users do
    resources :reviews, only: [:create]
  end
  
  resources :car_parts, only: [:index] do
    collection do
      get :fetch_models
    end
  end

  namespace :admin do
    resources :blog_posts
    root to: "blog_posts#index"
  end

  resources :blog_posts, only: [:index, :show] do
    resources :comments, only: [:create] do
      member do
        post 'like'
        post 'unlike'
      end
      resources :replies, only: [:create]
   end
  end
  

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
  root 'home#index'

end
