def remove_gem(*names)
  names.each do |name|
    gsub_file 'Gemfile', /gem ['"]#{name}['"].*\n/, ''
  end
end

def remove_comment_of_gem
  gsub_file('Gemfile', /^\s*#.*$\n/, '')
end

def replace_myapp(file)
  gsub_file file, /myapp/, app_name, verbose: false
end

def get_remote(src, dest = nil)
  dest ||= src
  if ENV['RAILS_TEMPLATE_DEBUG'].present?
    repo = File.join(File.dirname(__FILE__), 'files/')
  else
    repo = 'https://raw.githubusercontent.com/dao42/rails-template/master/files/'
  end
  remote_file = repo + src
  get(remote_file, dest, force: true)
  replace_myapp(dest)
end

def get_remote_dir(names, dir)
  names.each do |name|
    src = File.join(dir, name)
    get_remote(src)
  end
end

def yarn(lib)
  run("yarn add #{lib}")
end

def yarn_dev(lib)
  run("yarn add --dev #{lib}")
end

def remove_dir(dir)
  run("rm -rf #{dir}")
end

remove_comment_of_gem
# gitignore
get_remote('gitignore', '.gitignore')

# postgresql
say 'Applying postgresql...'
remove_gem('sqlite3')
gem 'pg', '>= 1.1'
get_remote('config/database.yml.example')
get_remote('config/database.yml.example', 'config/database.yml')

# environment variables set
say 'Applying figaro...'
gem 'figaro'
get_remote('config/application.yml.example')
get_remote('config/application.yml.example', 'config/application.yml')
get_remote('config/spring.rb')

say 'Applying jquery & font-awesome & bootstrap4...'
get_remote('package.json')

say 'Applying javascript & stylesheets from remote files...'
jss = ['base.js', 'application.js', 'admin.js']  #'ga.js.erb'
get_remote_dir(jss, 'app/javascript/')

admin_jss = ['sidebar.js']
get_remote_dir(admin_jss, 'app/javascript/admin/')

libs_jss = ['add_jquery.js']
get_remote_dir(libs_jss, 'app/javascript/libs/')

controllers_jss = ['index.js', 'admin_hello_controller.js']
get_remote_dir(controllers_jss, 'app/javascript/controllers/')

images = ['favicon.ico', 'logo.png', 'admin-user.jpg']
get_remote_dir(images, 'app/assets/images')

styles = ['application.scss', 'bootstrap_custom.scss', 'fontawsome_custom.scss', 'home.scss', 'admin.scss']
get_remote_dir(styles, 'app/assets/stylesheets/')

say 'Applying assets from remote files...'
assets = ['assets.rb']
get_remote_dir(assets, 'config/initializers/')

say 'Applying simple_form...'
gem 'simple_form', '~> 4.1'
after_bundle do
  generate 'simple_form:install', '--bootstrap'
end

say 'Applying slim...'
gem 'slim-rails'
say 'Applying high_voltage...'
gem 'high_voltage', '~> 3.1'
get_remote('app/controllers/home_controller.rb')
get_remote('app/helpers/application_helper.rb')
get_remote('app/views/home/index.html.slim')
get_remote('app/views/pages/about.html.slim')
remove_file('app/views/layouts/application.html.erb')
get_remote('app/views/layouts/application.html.slim')

say 'Applying action cable config...'
inject_into_file 'config/environments/production.rb', after: "# Mount Action Cable outside main process or domain.\n" do <<-EOF
  config.action_cable.allowed_request_origins = [ "\#{ENV['PROTOCOL']}://\#{ENV['DOMAIN']}" ]
EOF
end

# active_storage
# say 'Applying active_storage...'
# after_bundle do
  # rails_command 'active_storage:install'
# end

say 'Applying propshaft & css & js...'
gem 'cssbundling-rails'
gem 'jsbundling-rails'
gem 'propshaft', '~> 1.1.0'
get_remote('Procfile.dev')
get_remote('bin/dev')

# say "Applying browser_warrior..."
# gem 'browser_warrior', '>= 0.11.0'
# after_bundle do
  # generate 'browser_warrior:install'
# end

say 'Applying redis & sidekiq...'
gem 'sidekiq', '~> 7'
get_remote('config/initializers/sidekiq.rb')
get_remote('config/sidekiq.yml')
get_remote('config/routes.rb')
get_remote('config/secret.yml')

controllers = ['accounts_controller.rb', 'base_controller.rb', 'dashboard_controller.rb', 'sessions_controller.rb']
get_remote_dir(controllers, 'app/controllers/admin')
accounts_views = ['edit.html.slim']
get_remote_dir(accounts_views, 'app/views/admin/accounts')
dashboard_views = ['index.html.slim']
get_remote_dir(dashboard_views, 'app/views/admin/dashboard')
sessions_views = ['new.html.slim']
get_remote_dir(sessions_views, 'app/views/admin/sessions')
shared_admin_layouts = ['_flash_messages.html.slim', '_header.html.slim', '_sidebar.html.slim']
get_remote_dir(shared_admin_layouts, 'app/views/shared/admin')
admin_layouts = ['admin.html.slim']
get_remote_dir(admin_layouts, 'app/views/layouts')

# add db seeds
get_remote('db/seeds.rb')
gem 'bcrypt'
after_bundle do
  generate(:model, 'administrator', 'name:string:uniq:index', 'password:digest')
  inject_into_file 'app/models/administrator.rb', after: "class Administrator < ApplicationRecord\n" do <<-EOF
  validates :name, presence: true, uniqueness: true
EOF
  end
end

say 'Applying kaminari & rails-i18n...'
gem 'kaminari'
gem 'rails-i18n', '~> 7.0.10'
# after_bundle do
  # generate 'kaminari:config'
  # generate 'kaminari:views', 'bootstrap4'
# end

say 'Applying mina & its plugins...'
gem 'mina', '~> 1.2.2', require: false
gem 'mina-ng-puma', '>= 1.4.0', require: false
gem 'mina-multistage', require: false
gem 'mina-sidekiq', require: false
gem 'mina-logs', require: false
get_remote('config/deploy.rb')
get_remote('config/puma.rb')
get_remote('config/deploy/production.rb')
get_remote('config/nginx.conf.example')
get_remote('config/nginx.ssl.conf.example')
get_remote('config/logrotate.conf.example')

get_remote('config/monit.conf.example')
get_remote('config/backup.rb.example')

say 'Applying application config...'
inject_into_file 'config/application.rb', after: "class Application < Rails::Application\n" do <<-EOF
    config.generators.assets = false
    config.generators.helper = false
EOF
end

say 'Applying rspec test framework...'
gem_group :development do
  gem 'rails_apps_testing'
end
gem_group :development, :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails'
end
gem_group :test do
  gem 'database_cleaner'
  gem 'launchy'
end
after_bundle do
  generate 'testing:configure', 'rspec --force'
end

get_remote 'README.md'
get_remote 'ackrc', '.ackrc'
get_remote 'bin/setup'

after_bundle do
  say 'Almost done! Now init `git` and `database`...'
  rails_command 'db:drop'
  rails_command 'db:create'
  rails_command 'db:migrate'
  rails_command 'db:seed'
  git :init
  git add: '.'
  git commit: '-m "init rails with dao42/rails-template"'
  say 'Build successfully! input `rails s` to start your rails app...'
end
