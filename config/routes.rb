ActionController::Routing::Routes.draw do |map|
  map.resources :torrents, :collection => {:set_rate => :post} do |torrent|
    torrent.resources :files
    torrent.resources :peers
  end

  map.namespace :dwnl do |dwnl|
    dwnl.resources :web_jobs,
      :member => { 
        :start => :get
      }
  end

  map.with_options :controller => 'user_groups' do |ur|
    ur.user_groups       'user_groups',                   :action => "index"
    ur.update_user_group 'user_group/:user_id/:group_id', :action => "update" 
  end
  map.with_options :controller => 'group_permissions' do |ug|
    ug.group_permissions 'group_permissions/',            :action => "index"
    ug.group_permission  'group_permission/',             :action => "update"
  end  

  map.resources :local_networks, 
    :collection => { :set => :post },
    :member => { :get_ip => :post }
  map.resources :firewalls
  map.resources :fw_rules,
    :collection => { :nat => :get }
  map.resources :forward_ports
  map.resources :open_ports
  map.resources :dhcp_servers
  map.resources :services,
    :member => {
      :find => :post
    }
  map.resources :computers,
    :member => {
      :pass => :post,
      :block => :post,
    },
    :collection => { 
      :dhcp_list => :get
    }
  map.resources :users

  map.resource :session

  map.root :controller => 'sessions', :action => 'new'

  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
end
