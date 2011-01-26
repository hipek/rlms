Rlms::Application.routes.draw do
  namespace :router do
    resources :open_ports
    resources :forward_ports
    get "main" => "main#index", :as => :main
    put "main/update",          :as => :update_main
  end

  resources :torrents do
    resources :files
    resources :peers
    collection do
      post :set_rate
    end
  end

  namespace :dwnl do
    resources :web_jobs do
      member do
        get :start
      end
    end
  end

  match 'user_groups' => 'user_groups#index', :as => :user_groups
  match 'user_group/:user_id/:group_id' => 'user_groups#update', :as => :update_user_group
  match 'group_permissions/' => 'group_permissions#index', :as => :group_permissions
  match 'group_permission/' => 'group_permissions#update', :as => :group_permission

  resources :local_networks do
    collection do
      post :set
    end
    member do
      post :get_ip
    end
  end

  resources :firewalls
  resources :fw_rules do
    collection do
      get :nat
    end
  end

  resources :forward_ports
  resources :open_ports
  resources :dhcp_servers
  resources :services do
    member do
      post :find
    end
  end

  resources :computers do
    collection do
      get :dhcp_list
    end
    member do
      post :pass
      post :block
    end
  end

  resources :users
  resource :session

  match '/' => 'sessions#new'
  match '/logout' => 'sessions#destroy', :as => :logout
  match '/login' => 'sessions#new', :as => :login
end
