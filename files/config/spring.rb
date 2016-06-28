%w(
  .ruby-version
  .rbenv-vars
  tmp/restart.txt
  tmp/caching-dev.txt
  config/application.yml
).each { |path| Spring.watch(path) }
