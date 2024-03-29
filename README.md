# Normalizy

[![CI](https://github.com/wbotelhos/templaty/workflows/CI/badge.svg)](https://github.com/wbotelhos/templaty/actions)
[![Gem Version](https://badge.fury.io/rb/templaty.svg)](https://badge.fury.io/rb/templaty)
[![Maintainability](https://api.codeclimate.com/v1/badges/f312587b4f126bb13e85/maintainability)](https://codeclimate.com/github/wbotelhos/templaty/maintainability)
[![Coverage](https://codecov.io/gh/wbotelhos/templaty/branch/main/graph/badge.svg)](https://codecov.io/gh/wbotelhos/templaty)
[![Sponsor](https://img.shields.io/badge/sponsor-%3C3-green)](https://www.patreon.com/wbotelhos)

Rails template generator

- [Adding a column with default value](#adding-a-column-with-default-value)
- [CRUD](#crud)

## Description

It's an opinated Rails' template generator.

## install

Add the following code on your `Gemfile` and run `bundle install`:

```ruby
gem 'templaty'
```

## Migrations

There are many templates to create safe migrations for you. The strategies are based on the gem [strong_migrations](https://github.com/ankane/strong_migrations). It's recommended use the gem and just take advantage of these templates.

### Adding a column with default value

```ruby
rails g templaty:migrations:add_column \
  --column=status \
  --default=0 \
  --null=false \
  --rails_version=7.0 \
  --table=discounts \
  --type=integer
```

## CRUD

```ruby
rails g templaty:crud
```

## References

- [strong_migrations](https://github.com/ankane/strong_migrations)
