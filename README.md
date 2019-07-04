# rails-template

**rails-template has supported the newest rails( 6.0.0-rc1 ) setup**

A best & newest & fastest rails template for chinese senior rails developer.

It's a best starting for your new rails project.

An example built with rails-template: https://github.com/dao42/rails-template-example

## How to use

Install dependencies:

* postgresql

    `$ brew install postgresql`

    Ensure you have already initialized a user with username: `postgres` and password: `postgres`( e.g. `$ createuser -d postgres` )

* rails 5

    Update `ruby` up to 2.5 or higher, and install `rails 6.0.0-rc1`

    `$ ruby -v` ( output should be 2.5.x or 2.6.x )

    `$ gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.com/` (optional)

    `$ gem install rails`

    `$ rails -v` ( output should be rails 6.0.0-rc1 )

Then,

1. Add `gems.ruby-china.com` to your bundle mirrors (optional)

    `$ bundle config mirror.https://rubygems.org https://gems.ruby-china.com`

2. Create your own rails app applying `rails-template`

    `$ rails new myapp -m https://raw.github.com/dao42/rails-template/master/composer.rb`

## What we do

`rails-template` apply lots of good components for you to make development damn quick.

1. `ActionCable` and `Turbolinks` features are opened by default.

2. `Bootstrap4` and `font-awesome` are integrated to make your products UI easily, it aslo has some example pages for you to quickly start.

3. `active_storage` and `local` file mode are opened by default.

4. `mina` and its plugins are the best & simplest deployment tools in the world for rails app.

5. `slim`, `rspec`, `high_voltage` and so on.

6. Zero-down phase-restart mode is opened with `mina-ng-puma`

Other gems integrated in rails-template are worth learning seriously.

## Integrated mainly technology stack

* Ruby on Rails 6.0
* bootstrap 4
* font-awesome
* figaro
* postgres
* slim
* simple_form
* high_voltage
* active_storage & upyun
* sidekiq
* kaminari
* mina
* puma
* lograge

## Deployment document

* [How to deploy to ubuntu 16.10 with rails-template step by step(zh-CN)](https://github.com/80percent/rails-template/wiki/how-to-deploy-rails-to-ubuntu1404-with-rails-template)

## Projects that using `rails-template`

Welcome to pull request to update this if you choose `rails-template` for your new rails app.

* [单麦小程序平台](https://www.danmai.com.cn)
* [至简天成科技](https://www.dao42.com)

## LICENSE

MIT
