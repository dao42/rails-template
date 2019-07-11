# dao42/rails-template

**dao42/rails-template has supported the newest rails( 6.0.0-rc1 ) project setup**

Maybe the best & newest & fastest rails template for senior rails developer.

It maybe the best starting for your new rails project.

An example built with rails-template: https://github.com/dao42/rails-template-example


## Core Idea

`dao42/rails-template` apply lots of good components for you to make development damn quick.

1. `dao42/rails-template` keep the newest easily because it's a real `Rails Application Template`.
2. `dao42/rails-template` love the newest standard components of Rails 6, using `webpacker` and remove `assets pipeline`.
3. `dao42/rails-template` is out-of-box for your development based on `bootstrap4`.
4. `dao42/rails-template` is out-of-box for your deployment based on `mina`.

## How to use

Install dependencies:

* postgresql

    ```bash
    $ brew install postgresql
    ```

    Ensure you have already initialized a user with username: `postgres` and password: `postgres`( e.g. using `$ createuser -d postgres` command creating one )

* rails 6

    Using `rbenv`, update `ruby` up to 2.5 or higher, and install `rails 6.0.0-rc1`

    ```bash
    $ ruby -v ( output should be 2.5.x or 2.6.x )

    $ gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.com/` (optional, Chinese developer recommend)

    $ gem install rails

    $ rails -v ( output should be rails 6.0.0-rc1 )
    ```

* yarn

    Install `npm`, `yarn` for webpacker( see install document: https://yarnpkg.com/en/docs/install)

    ```bash
    $ yarn --version( output should be 1.6.x or higher )

    $ npm config set registry https://registry.npm.taobao.org (optional, Chinese developer recommend)
    ```

Then,

1. Add `gems.ruby-china.com` to your bundle mirrors (optional, Chinese developer recommended)

    `$ bundle config mirror.https://rubygems.org https://gems.ruby-china.com`

2. Create your own rails app applying `rails-template`

    `$ rails new myapp -m https://raw.github.com/dao42/rails-template/master/composer.rb`

    Important!! replace `myapp` to your real project name, we will generate lots of example files by this name.

3. Done! Trying to start it.

    `$ rails s`

## What we do

`rails-template` apply lots of good components for you to make development damn quick.

1. `ActionCable` and `Turbolinks` features are opened by default.

2. `Bootstrap4` and `font-awesome` are integrated to make your products UI easily, it aslo has some example pages for you to quickly start.

3. `active_storage` and `local` file mode are opened by default.

4. `mina` and its plugins are out-of-box for your deployment.

5. `slim`, `simple_form`, `kaminari`, `high_voltage` are installed.

6. `rspec`, `factory_bot_rails`, `database_cleaner` are ready for your testing automation.

6. Zero-down phase-restart mode is out-of-box with `mina-ng-puma`.

7. `monit`, `nginx example`, `https ssl example`, `logrotate`, `backup example` is ready for you.

Other gems integrated in rails-template are worth learning seriously.

## Integrated mainly technology stack and gems

* Ruby on Rails 6.0
* bootstrap 4
* font-awesome 5
* figaro
* postgres
* slim
* simple_form
* high_voltage
* active_storage
* sidekiq
* kaminari
* mina
* puma
* rspec

## Starting with webpacker document

* [Starting with webpacker for Rails 6(zh-CN)](https://ruby-china.org/topics/38832)

## Deployment document

* [How to deploy to ubuntu 16.10 with rails-template step by step(zh-CN)](https://github.com/dao42/rails-template/wiki/how-to-deploy-rails-to-ubuntu1404-with-rails-template)

## Roadmap

* [ ] Add AdminLTE as admin dashboard

## Projects that using `dao42/rails-template`

Welcome to pull request here to update this if you choose `dao42/rails-template` for your new rails app.

* [danmai weapp SAAS platform](https://www.danmai.com.cn)
* [dao42 official website](https://www.dao42.com)

## LICENSE

MIT
