set :stages, %w(production)
set :default_stage, 'production'

set :shared_dirs, ['log', 'public/uploads']
set :shared_files, ['config/database.yml', 'config/application.yml']
set :puma_config, ->{ "#{fetch(:current_path)}/config/puma.rb" }
set :sidekiq_pid, ->{ "#{fetch(:shared_path)}/tmp/pids/sidekiq.pid" }

require 'mina/multistage'
require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'
require 'mina/puma'
require "mina_sidekiq/tasks"
require 'mina/logs'

task :environment do
  invoke :'rbenv:load'
end

task :setup => :environment do
  command %[mkdir -p "#{fetch(:shared_path)}/tmp/sockets"]
  command %[chmod g+rx,u+rwx "#{fetch(:shared_path)}/tmp/sockets"]

  command %[mkdir -p "#{fetch(:shared_path)}/tmp/pids"]
  command %[chmod g+rx,u+rwx "#{fetch(:shared_path)}/tmp/pids"]

  command %[mkdir -p "#{fetch(:shared_path)}/log"]
  command %[chmod g+rx,u+rwx "#{fetch(:shared_path)}/log"]

  command %[mkdir -p "#{fetch(:shared_path)}/public/uploads"]
  command %[chmod g+rx,u+rwx "#{fetch(:shared_path)}/public/uploads"]

  command %[mkdir -p "#{fetch(:shared_path)}/config"]
  command %[chmod g+rx,u+rwx "#{fetch(:shared_path)}/config"]

  command %[touch "#{fetch(:shared_path)}/config/application.yml"]
  command %[echo "-----> Be sure to edit '#{fetch(:shared_path)}/config/application.yml'"]

  command %[touch "#{fetch(:shared_path)}/config/database.yml"]
  command %[echo "-----> Be sure to edit '#{fetch(:shared_path)}/config/database.yml'"]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  command %[echo "-----> Server: #{fetch(:domain)}"]
  command %[echo "-----> Path: #{fetch(:deploy_to)}"]
  command %[echo "-----> Branch: #{fetch(:branch)}"]

  deploy do
    invoke :'sidekiq:quiet'
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      invoke :'rbenv:load'
      invoke :'puma:hard_restart'
      invoke :'sidekiq:restart'
    end
  end
end

desc "Deploys the current version to the server."
task :first_deploy => :environment do
  command %[echo "-----> Server: #{fetch(:domain)}"]
  command %[echo "-----> Path: #{fetch(:deploy_to)}"]
  command %[echo "-----> Branch: #{fetch(:branch)}"]

  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'deploy:cleanup'

    on :launch do
      invoke :'rbenv:load'
      invoke :'rails:db_create'
    end
  end
end
