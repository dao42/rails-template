def remove_gem(*names)
  names.each do |name|
    gsub_file 'Gemfile', /gem '#{name}'\n/, ''
  end
end

def remove_comment_of_gem
  gsub_file('Gemfile', /^\s*#.*$\n/, '')
end

def get_remote(src, dest)
  repo = 'https://raw.github.com/80percent/rails-template/master/files/'
  remote_file = repo + src
  remove_file dest
  get(remote_file, dest)
end

remove_comment_of_gem
# gitignore
get_remote('gitignore', '.gitignore')

# postgresql
remove_gem('sqlite3')
gem 'pg'
remove_file 'config/database.yml'
get_remote('config/database.yml.example', 'config/database.yml.example')
gsub_file "config/database.yml.example", /database: myapp_development/, "database: #{app_name}_development"
gsub_file "config/database.yml.example", /database: myapp_test/, "database: #{app_name}_test"
gsub_file "config/database.yml.example", /database: myapp_production/, "database: #{app_name}_production"

# environment variables
gem 'figaro'
get_remote('config/application.yml.example', 'config/application.yml.example')
get_remote('config/secret.yml', 'config/secret.yml')


# bootstrap sass
gem 'bootstrap-sass'
remove_file 'app/assets/stylesheets/application.css'
get_remote('application.scss', 'app/assets/stylesheets/application.scss')
inject_into_file 'app/assets/javascripts/application.js', after: "//= require jquery\n" do "//= require bootstrap-sprockets\n" end

gem 'font-awesome-sass'
gem 'slim-rails'
gem 'high_voltage', :github=>"thoughtbot/high_voltage"

# TODO
# initialize files
# uploader directory
# application.yml
gem 'carrierwave'
gem 'carrierwave-upyun'

# TODO initialize files
gem 'status-page'

#gem 'redis-namespace'
#gem 'sidekiq'
#gem 'sinatra', github: 'sinatra', require: false
#gem 'kaminari', github: 'amatsuda/kaminari'
#gem 'rails-i18n', '~> 5.0.0.beta1'

#gem 'mina-puma', require: false
#gem 'mina-multistage', '~> 1.0', '>= 1.0.2', require: false
#gem 'mina-sidekiq', '~> 0.3.1', require: false
#gem 'mina-logs', '>= 0.1.0', require: false

#gem 'lograge'

after_bundle do
  #TODO
end
