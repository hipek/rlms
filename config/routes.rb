Rlms::Application.routes.draw do
  scope Rails.application.config.relative_url_root do
    namespace :admin do
      get "base/index", :as => :admin
    end

    namespace :router do
      resources :config_files do
        collection do
          get :dhcp
          get :iptables
        end
      end
      resources :dhcps
      resources :tc_classids
      resources :flows
      resources :open_ports
      resources :forward_ports
      resources :services, :only => [:update, :index] do
        member do
          post :find
        end
      end
      resources :computers do
        member do
          post :pass
          post :block
        end
      end
      get "main" => "main#index", :as => :main
      put "main/update",          :as => :update_main
    end

    namespace :torrent do
      resources :items do
        collection do
          post :set_rate
        end
        resources :files
        resources :peers
      end
    end

    namespace :dwnl do
      resources :web_jobs do
        member do
          get :start
        end
      end
    end

    resources :fw_rules

    get 'user_groups' => 'user_groups#index', :as => :user_groups
    post 'user_group/:user_id/:group_id' => 'user_groups#update', :as => :update_user_group
    get 'group_permissions/' => 'group_permissions#index', :as => :group_permissions
    post 'group_permission/' => 'group_permissions#update', :as => :group_permission

    resources :users
    resource :session

    root 'sessions#new'
    get '/logout' => 'sessions#destroy', :as => :logout
    get '/login' => 'sessions#new', :as => :login
  end
end
