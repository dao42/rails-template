def remove_gem(*names)
  names.each do |name|
    gsub_file 'Gemfile', /gem '#{name}'\n/, ''
  end
end

def remove_comment_of_gem
  gsub_file('Gemfile', /^\s*#.*$\n/, '')
end

def get_remote(src, dest = nil)
  dest ||= src
  repo = 'https://raw.github.com/80percent/rails-template/master/files/'
  #repo = File.join(File.dirname(__FILE__), 'files/')
  remote_file = repo + src
  remove_file dest
  get(remote_file, dest)
end

remove_comment_of_gem
# gitignore
get_remote('gitignore', '.gitignore')

# postgresql
say 'Applying postgresql...'
remove_gem('sqlite3')
gem 'pg', '0.18'
get_remote('config/database.yml.example')
gsub_file "config/database.yml.example", /database: myapp_development/, "database: #{app_name}_development"
gsub_file "config/database.yml.example", /database: myapp_test/, "database: #{app_name}_test"
gsub_file "config/database.yml.example", /database: myapp_production/, "database: #{app_name}_production"
get_remote('config/database.yml.example', 'config/database.yml')
gsub_file "config/database.yml", /database: myapp_development/, "database: #{app_name}_development"
gsub_file "config/database.yml", /database: myapp_test/, "database: #{app_name}_test"
gsub_file "config/database.yml", /database: myapp_production/, "database: #{app_name}_production"

# environment variables set
say 'Applying figaro...'
gem 'figaro'
get_remote('config/application.yml.example')
get_remote('config/application.yml.example', 'config/application.yml')
get_remote('config/spring.rb')

after_bundle do
  say "Stop spring if exsit"
  run "spring stop"
end

# jquery, bootstrap needed
say 'Applying jquery...'
gem 'jquery-rails'
inject_into_file 'app/assets/javascripts/application.js', after: "//= require rails-ujs\n" do "//= require jquery\n" end

# bootstrap sass
say 'Applying bootstrap4...'
gem 'bootstrap', '~> 4.1.0'
remove_file 'app/assets/stylesheets/application.css'
get_remote('application.scss', 'app/assets/stylesheets/application.scss')
inject_into_file 'app/assets/javascripts/application.js', after: "//= require jquery\n" do "//= require popper\n//= require bootstrap-sprockets\n" end

say 'Applying simple_form...'
gem 'simple_form', '~> 4.0.0'
after_bundle do
  generate 'simple_form:install', '--bootstrap'
end

say 'Applying font-awesome & slim & high_voltage...'
gem 'font-awesome-sass'
gem 'slim-rails'
gem 'high_voltage', '~> 3.0.0'
get_remote('home_controller.rb', 'app/controllers/home_controller.rb')
get_remote('index.html.slim', 'app/views/home/index.html.slim')
get_remote('about.html.slim', 'app/views/pages/about.html.slim')
remove_file('app/views/layouts/application.html.erb')
get_remote('application.html.slim', 'app/views/layouts/application.html.slim')
gsub_file 'app/views/layouts/application.html.slim', /myapp/, "#{app_name}"
get_remote('favicon.ico', 'app/assets/images/favicon.ico')

say 'Applying action cable config...'
inject_into_file 'config/environments/production.rb', after: "# Mount Action Cable outside main process or domain\n" do <<-EOF
  config.action_cable.allowed_request_origins = [ "\#{ENV['PROTOCOL']}://\#{ENV['DOMAIN']}" ]
EOF
end

# active_storage
say 'Applying active_storage...'
after_bundle do
  rake 'active_storage:install'
end

# initialize files
say 'Applying status page...'
gem 'status-page'
get_remote('config/initializers/status_page.rb')

say "Applying browser_warrior..."
gem 'browser_warrior', '>= 0.8.0'
after_bundle do
  generate 'browser_warrior:install'
end

say 'Applying redis & sidekiq...'
gem 'redis-namespace'
gem 'sidekiq'
get_remote('config/initializers/sidekiq.rb')
get_remote('config/routes.rb')

say 'Applying kaminari & rails-i18n...'
gem 'kaminari', '~> 1.1.1'
gem 'rails-i18n', '~> 5.0.3'
after_bundle do
  generate 'kaminari:config'
  generate 'kaminari:views', 'bootstrap4'
end

say 'Applying mina & its plugins...'
gem 'mina', '~> 1.2.2', require: false
gem 'mina-puma', '~> 1.1.0', require: false
gem 'mina-multistage', '~> 1.0.3', require: false
gem 'mina-sidekiq', '~> 1.0.3', require: false
gem 'mina-logs', '~> 1.1.0', require: false
get_remote('config/deploy.rb')
get_remote('config/puma.rb')
gsub_file 'config/puma.rb', /\/data\/www\/myapp\/shared/, "/data/www/#{app_name}/shared"
get_remote('config/deploy/production.rb')
gsub_file 'config/deploy/production.rb', /\/data\/www\/myapp/, "/data/www/#{app_name}"
get_remote('config/nginx.conf.example')
gsub_file 'config/nginx.conf.example', /myapp/, "#{app_name}"
get_remote('config/nginx.ssl.conf.example')
gsub_file 'config/nginx.ssl.conf.example', /myapp/, "#{app_name}"
get_remote('config/logrotate.conf.example')
gsub_file 'config/logrotate.conf.example', /myapp/, "#{app_name}"

get_remote('config/monit.conf.example')
gsub_file 'config/monit.conf.example', /myapp/, "#{app_name}"

get_remote('config/backup.rb.example')
gsub_file 'config/backup.rb.example', /myapp/, "#{app_name}"

say 'Applying lograge & basic application config...'
gem 'lograge'
inject_into_file 'config/application.rb', after: "class Application < Rails::Application\n" do <<-EOF
    config.generators.assets = false
    config.generators.helper = false

    config.time_zone = 'Beijing'
    config.i18n.available_locales = [:en, :'zh-CN']
    config.i18n.default_locale = :'zh-CN'

    config.lograge.enabled = true
EOF
end

get_remote 'README.md'
gsub_file 'README.md', /myapp/, "#{app_name}"
# `ack` is a really quick tool for searching code
get_remote 'ackrc', '.ackrc'

after_bundle do
  say 'Done! init `git` and `database`...'
  git :init
  git add: '.'
  git commit: '-m "init rails"'

  rake 'db:create'
  say "Build successfully! `cd #{app_name}` and use `rails s` to start your rails app..."
end
