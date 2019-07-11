def remove_gem(*names)
  names.each do |name|
    gsub_file 'Gemfile', /gem '#{name}'\n/, ''
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
    repo = 'https://raw.github.com/dao42/rails-template/master/files/'
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

def remove_dir(dir)
  run("rm -rf #{dir}")
end

remove_comment_of_gem
# gitignore
get_remote('gitignore', '.gitignore')

# postgresql
say 'Applying postgresql...'
remove_gem('sqlite3')
gem 'pg', '0.18'
get_remote('config/database.yml.example')
get_remote('config/database.yml.example', 'config/database.yml')

# environment variables set
say 'Applying figaro...'
gem 'figaro'
get_remote('config/application.yml.example')
get_remote('config/application.yml.example', 'config/application.yml')
get_remote('config/spring.rb')

after_bundle do
  say "Stop spring if exists"
  run "spring stop"
end

say 'Applying webpack peer...'
after_bundle do
  yarn 'webpack@^4.0.0'
end

say 'Applying jquery...'
after_bundle do
  yarn 'jquery@^3.3.1'
end

say 'Applying font-awesome...'
after_bundle do
  yarn '@fortawesome/fontawesome-free@^5.9.0'
end

say 'Applying bootstrap4...'
after_bundle do
  yarn 'popper.js@^1.14.7'
  yarn 'bootstrap@^4.3.1'
end

remove_dir 'app/assets'
jss = [ 'base.js' ]
get_remote_dir(jss, 'app/javascript/js')
images = [ 'favicon.ico' ]
get_remote_dir(images, 'app/javascript/images')
styles = [ 'application.scss', 'bootstrap_custom.scss', 'home.scss' ]
get_remote_dir(styles, 'app/javascript/styles')
packs = [ 'application.js' ]
get_remote_dir(packs, 'app/javascript/packs')

say 'Applying simple_form...'
gem 'simple_form', '~> 4.0.0'
after_bundle do
  generate 'simple_form:install', '--bootstrap'
end

say 'Applying slim...'
gem 'slim-rails'
say 'Applying high_voltage...'
gem 'high_voltage', '~> 3.0.0'
get_remote('app/controllers/home_controller.rb')
get_remote('app/helpers/application_helper.rb')
get_remote('app/views/home/index.html.slim')
get_remote('app/views/pages/about.html.slim')
remove_file('app/views/layouts/application.html.erb')
get_remote('app/views/layouts/application.html.slim')

say 'Applying action cable config...'
inject_into_file 'config/environments/production.rb', after: "# Mount Action Cable outside main process or domain\n" do <<-EOF
  config.action_cable.allowed_request_origins = [ "\#{ENV['PROTOCOL']}://\#{ENV['DOMAIN']}" ]
EOF
end

# active_storage
say 'Applying active_storage...'
after_bundle do
  rails_command 'active_storage:install'
end

say "Applying browser_warrior..."
gem 'browser_warrior', '>= 0.11.0'
after_bundle do
  generate 'browser_warrior:install'
end

say 'Applying redis & sidekiq...'
gem 'sidekiq'
get_remote('config/initializers/sidekiq.rb')
get_remote('config/sidekiq.yml')
get_remote('config/routes.rb')
get_remote('config/secret.yml')

say 'Applying kaminari & rails-i18n...'
gem 'kaminari', '~> 1.1.1'
gem 'rails-i18n', '~> 6.0.0.beta1'
after_bundle do
  generate 'kaminari:config'
  generate 'kaminari:views', 'bootstrap4'
end

say 'Applying mina & its plugins...'
gem 'mina', '~> 1.2.2', require: false
gem 'mina-ng-puma', '>= 1.3.0', require: false
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

    config.time_zone = 'Beijing'
    config.i18n.available_locales = [:en, :'zh-CN']
    config.i18n.default_locale = :'zh-CN'
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
  gem 'capybara'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'selenium-webdriver'
end
after_bundle do
  generate 'testing:configure', 'rspec --force'
end

get_remote 'README.md'
# `ack` is a really quick tool for searching code
get_remote 'ackrc', '.ackrc'

after_bundle do
  say 'Almost done! init `git` and `database`...'
  rails_command 'db:create'
  rails_command 'db:migrate'
  rails_command 'db:seed'
  run 'bin/webpack'
  git :init
  git add: '.'
  git commit: '-m "init rails with dao42/rails-template"'
  say "Build successfully! `cd #{app_name}` and input `rails s` to start your rails app..."
end
