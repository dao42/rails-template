# myapp
The source code of myapp

## Installation

Install dependencies:

* postgresql

    ```bash
    $ brew install postgresql
    ```

    Ensure you have already initialized a user with username: `postgres` and password: `postgres`( e.g. using `$ createuser -d postgres` command creating one )

* rails 7

    Using `rbenv`, update `ruby` up to 3.x, and install `rails 7.x`

    ```bash
    $ ruby -v ( output should be 3.x )

    $ gem install rails

    $ rails -v ( output should be rails 7.x )
    ```

* yarn

    Install `yarn` for webpacker( see install document: https://yarnpkg.com/en/docs/install)

    ```bash
    $ yarn --version ( output should be 1.6.x or higher )
    ```

Install dependencies, setup db:
```bash
$ ./bin/setup
```

Start it:
```
$ rails s
```


## Admin dashboard info

Access url: /admin

Default superuser: admin

Default password: admin

## Tech stack

* Ruby on Rails 7.x
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
* adminlte 3

## Built with

[dao42/rails-template](https://github.com/dao42/rails-template)

## LICENSE

MIT
