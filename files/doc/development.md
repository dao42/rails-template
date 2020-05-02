# Readme for Developers

## Quality criteria

In order to follow some quality criteria during development, some Ruby gems and tools are used in this app.

### Security

#### brakeman

[Brakeman](https://rubygems.org/gems/brakeman) detects security vulnerabilities in Ruby on Rails applications via static analysis.

`$ brakeman -AI`

#### Bundler-Audit

[bundler-audit](https://rubygems.org/gems/bundler-audit) provides patch-level verification for Bundled apps.

Update audit db:

`$ bundle-audit update`

Run checks:

`$ bundle-audit check`

### Performance

#### Bullet

[Bullet](https://rubygems.org/gems/bullet) helps to kill N+1 queries and unused eager loading.

### Source code

#### EditorConfig

[EditorConfig](https://editorconfig.org) helps maintain consistent coding styles for multiple developers working on the same project across various editors and IDEs.

#### RuboCop

Automatic Ruby [code style checking tool](https://rubygems.org/gems/rubocop) aims to enforce the community-driven Ruby Style Guide.

`$ rubocop -Ea -C true`

#### Solargraph

[IDE tools](https://rubygems.org/gems/solargraph) for code completion, inline documentation, and static analysis.

#### IDE Extensions

Also check out some Microsoft Visual Studio Code Extensions.

[EditorConfig for VS Code](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig)
[Ruby Rubocop](https://marketplace.visualstudio.com/items?itemName=misogi.ruby-rubocop)
[Ruby Solargraph](https://marketplace.visualstudio.com/items?itemName=castwide.solargraph)

### Other tools

#### LicenseFinder

[LicenseFinder](https://rubygems.org/gems/license_finder) works with your package managers to find dependencies, detect the licenses of the packages in them, compare those licenses against a user-defined list of permitted licenses, and give you an actionable exception report.

The first time you run license_finder it will list all your project's packages.

`$ license_finder`

To [approve dependencies](https://github.com/pivotal/LicenseFinder#approving-dependencies) e.g. run:

`$ license_finder approvals add awesome_gpl_gem`

or

`$ license_finder permitted_licenses add MIT`

#### Rails console

Add to your `~/.irbrc`:

```bash
require 'irb/completion'

IRB.conf[:PROMPT_MODE] = :SIMPLE
IRB.conf[:AUTO_INDENT_MODE] = false
IRB.conf[:SAVE_HISTORY] = 2000

```

#### Pry Rails

[Pry](https://rubygems.org/gems/pry) is a runtime developer console and IRB alternative with powerful introspection capabilities. Pry aims to be more than an IRB replacement. It is an attempt to bring [REPL driven programming](https://pry.github.io/) to the Ruby language.

[byebug](https://rubygems.org/gems/pry-byebug) adds 'step', 'next', 'finish', 'continue' and 'break' commands to control execution.

Add to your `~/.pryrc`:

```bash
Pry.config.prompt = PryRails::RAILS_PROMPT if defined?(PryRails::RAILS_PROMPT)
```
