app_name = "ninjachoice"
app_path = "/var/www/rails/#{app_name}"

set :application, app_name
set :repo_url, "git@github.com:carlosalan/#{app_name}.git"

set :deploy_to, app_path
set :keep_releases, 5

set :linked_files, %w{config/database.yml .env}

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
      execute "bash --login #{app_path}/current/config/unicorn_init.sh"
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

  after :finishing, 'deploy:cleanup'
end
        require './config/boot'
        require 'airbrake/capistrano'
