set :application, "r-lms"
set :repository,  "http://ltg.one.pl/svn/repos/r-lms/"

set :user, "rails"
set :use_sudo,  false

set :deploy_to, "/home/rails/production/#{application}"
set :config,    "#{deploy_to}/config"
set :deploy_via, :export
#set :copy_strategy, :export

set :krd_server, "krd.webhop.org"

role :app, krd_server
role :web, krd_server
role :db,  krd_server, :primary => true

task :after_setup, :roles => :app do
  run "umask 02 && mkdir -p #{deploy_to}/config"
  run "cd #{deploy_to}/config && cp ../current/config/database.yml.example ./database.yml"
  run "cd #{deploy_to}/config && cp ../current/config/mongrel_cluster.yml.example ./mongrel_cluster.yml"  
  run "cd #{deploy_to}/config && cp ../current/config/environments/production.rb.example ./production.rb"
end

task :before_finalize_update, :roles => :app do
  run "cd #{current_release} && ln -fs #{config}/database.yml ./config/database.yml"
  run "cd #{current_release} && ln -fs #{config}/rtorrent.yml ./config/rtorrent.yml"
  run "cd #{current_release} && ln -fs #{config}/mongrel_cluster.yml ./config/mongrel_cluster.yml"  
  run "cd #{current_release} && ln -fs #{config}/production.rb ./config/environments/production.rb"
  run "cd #{current_release} && ln -fs #{deploy_to}/shared/downloads ./public/downloads"
end

task :passenger_restart, :roles => :app do
  run "touch #{current_release}/tmp/restart.txt"
end

namespace :deploy do
  task :restart do
    #sudo "/etc/init.d/apache2 restart"
    passenger_restart
  end
  task :start do
    # nothing
  end
  task :stop do
    # nothing
  end
end
