# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'rlms4'
set :repo_url, 'git@git.bananapi.dev:ruby/rlms.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/deploy/rlms4'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/rtorrent.yml config/secrets.yml config/settings.yml db/production.sqlite3}

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  desc 'Copy configs to share dir'
  task :check_configs do
    on roles(:web, :app) do
      execute :mkdir, "-p #{shared_path}/config"
      %w'database.yml rtorrent.yml secrets.yml'.each do |file|
        fullname = File.join(shared_path, 'config', file)
        unless test("[ -f #{fullname} ]")
          upload! "config/#{file}", fullname
        end
      end
    end
  end

  after 'deploy:check:directories', 'deploy:check_configs'
end
