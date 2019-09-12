STDOUT.sync = true
set :stages, %w(production)
set :default_stage, 'production'

require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'
require 'mina/puma'
require "mina_sidekiq/tasks"
require 'mina/logs'
require 'mina/multistage'

set :asset_dirs, fetch(:asset_dirs, []).push('app/javascript')
set :shared_dirs, fetch(:shared_dirs, []).push('log', 'public/uploads', 'public/packs', 'node_modules', 'storage')
set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/application.yml')

set :puma_config, ->{ "#{fetch(:current_path)}/config/puma.rb" }
set :sidekiq_pid, ->{ "#{fetch(:shared_path)}/tmp/pids/sidekiq.pid" }

task :remote_environment do
  invoke :'rbenv:load'
end

task :setup do
  command %[mkdir -p "#{fetch(:shared_path)}/tmp/sockets"]
  command %[chmod g+rx,u+rwx "#{fetch(:shared_path)}/tmp/sockets"]

  command %[mkdir -p "#{fetch(:shared_path)}/tmp/pids"]
  command %[chmod g+rx,u+rwx "#{fetch(:shared_path)}/tmp/pids"]

  command %[mkdir -p "#{fetch(:shared_path)}/log"]
  command %[chmod g+rx,u+rwx "#{fetch(:shared_path)}/log"]

  command %[mkdir -p "#{fetch(:shared_path)}/public/uploads"]
  command %[chmod g+rx,u+rwx "#{fetch(:shared_path)}/public/uploads"]

  command %[mkdir -p "#{fetch(:shared_path)}/public/packs"]
  command %[chmod g+rx,u+rwx "#{fetch(:shared_path)}/public/packs"]

  command %[mkdir -p "#{fetch(:shared_path)}/node_modules"]
  command %[chmod g+rx,u+rwx "#{fetch(:shared_path)}/node_modules"]

  command %[mkdir -p "#{fetch(:shared_path)}/storage"]
  command %[chmod g+rx,u+rwx "#{fetch(:shared_path)}/storage"]

  command %[mkdir -p "#{fetch(:shared_path)}/config"]
  command %[chmod g+rx,u+rwx "#{fetch(:shared_path)}/config"]

  command %[touch "#{fetch(:shared_path)}/config/application.yml"]
  command %[echo "-----> Be sure to edit '#{fetch(:shared_path)}/config/application.yml'"]

  command %[touch "#{fetch(:shared_path)}/config/database.yml"]
  command %[echo "-----> Be sure to edit '#{fetch(:shared_path)}/config/database.yml'"]
end

desc "Clear bootsnap cache"
task :clear_bootsnap do
  command %[echo "Clear bootsnap cache..."]
  command %[rm -rf "#{fetch(:shared_path)}/tmp/bootsnap-*"]
end

desc "Deploys the current version to the server."
task :deploy do
  command %[echo "-----> Server: #{fetch(:domain)}"]
  command %[echo "-----> Path: #{fetch(:deploy_to)}"]
  command %[echo "-----> Branch: #{fetch(:branch)}"]

  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :clear_bootsnap
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      invoke :'rbenv:load'
      invoke :'sidekiq:quiet'
      invoke :'puma:smart_restart'
      invoke :'sidekiq:restart'
    end
  end
end

desc "Prepare the first deploy on server."
task :first_deploy do
  command %[echo "-----> Server: #{fetch(:domain)}"]
  command %[echo "-----> Path: #{fetch(:deploy_to)}"]
  command %[echo "-----> Branch: #{fetch(:branch)}"]

  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      invoke :'rbenv:load'
      invoke :'rails:db_create'
      invoke :'rails', 'db:migrate'
      invoke :'rails', 'db:seed'
    end
  end
end
