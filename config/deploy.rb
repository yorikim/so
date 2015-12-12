# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'so'
set :repo_url, 'https://github.com/yorikim/so.git'

# Default deploy_to directory is /var/www/my_app
set :deploy_to, "/home/deployer/so"
set :deploy_user, 'deployer'


# Default value for :linked_files is []
set :linked_files, %w{config/secrets.yml config/database.yml config/private_pub.yml config/private_pub_thin.yml .env}

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}

set :default_shell, '/bin/bash -l'

# namespace :deploy do
#   desc 'Restart application'
#   task :restart do
#     on roles(:app), in: :sequence, wait: 5 do
#       # Your restart mechanism here, for example:
#       execute :touch, release_path.join('tmp/restart.txt')
#     end
#   end
#
#   after :publishing, :restart
# end
#
# namespace :private_pub do
#   desc 'Start private_pub server'
#   task :start do
#     on roles(:app) do
#       within current_path do
#         with rails_env: fetch(:rails_env) do
#           execute :bundle, "exec thin -C config/private_pub_thin.yml start"
#         end
#       end
#     end
#   end
#
#   desc 'Stop private_pub server'
#   task :stop do
#     on roles(:app) do
#       within current_path do
#         with rails_env: fetch(:rails_env) do
#           execute :bundle, "exec thin -C config/private_pub_thin.yml stop"
#         end
#       end
#     end
#   end
#
#   desc 'Restart private_pub server'
#   task :restart do
#     on roles(:app) do
#       within current_path do
#         with rails_env: fetch(:rails_env) do
#           execute :bundle, "exec thin -C config/private_pub_thin.yml restart"
#         end
#       end
#     end
#   end
# end
#
# after 'deploy:restart', 'private_pub:restart'
