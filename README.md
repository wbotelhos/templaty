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
rails g templaty:crud \
  --avatar=false \
  --belongs_to=unit \
  --cover=false \
  --fields_grid=100,50:50 \
  --fields_i18n=Nome,Porcentagem,Valor \
  --fields_presence=name \
  --fields=name,percentage_cents,amount_cents \
  --gender=male \
  --multipart=false \
  --name_one=desconto \
  --name_other=descontos \
  --namespace_i18n=sistema \
  --namespace=system \
  --path=descontos \
  --photos=false \
  --show_route=false \
  --table=discounts \
  --validates_numericality=amount_cents:0:999_99,percentage_cents:0:100_00
```

```
| Property               | Description                  |
|-------------------------------------------------------|
| avatar                 |                              |
| belongs_to             |                              |
| cover                  |                              |
| fields_grid            |                              |
| fields_i18n            |                              |
| fields_presence        |                              |
| fields                 |                              |
| gender                 |                              |
| multipart              |                              |
| name_one               |                              |
| name_other             |                              |
| namespace_i18n         |                              |
| namespace              |                              |
| path                   |                              |
| photos                 |                              |
| show_route             |                              |
| table                  |                              |
| validates_numericality |                              |
```

### Ignoring Resources

```
| Property              | Value            | Description                                  |
|-----------------------------------------------------------------------------------------|
| `ignore_routes`       | `true`           | Ignores routes creation.                     |
| `ignore_actions`      | `create,destroy` | Ignores the controller's actions.            |
| `ignore_css`          | `form,index`     | Skips CSS files.                             |
| `ignore_hbs`          | `gridy,search`   | Ignores the HBS templates.                   |
| `ignore_i18n_locales` | `en,pt-BR`       | Ignores the I18n of the entire given locale. |
| `ignore_i18n_actions` | `create,update`  | Ignores the I18n of the given actions.       |
| `ignore_ignore_js`    | `form,index`     | Ignores the given JS files.                  |
| `ignore_model`        | `true`           | Ignores the model.                           |
| `ignore_views`        | `_form,gridy`    | Ignores the given views.                     |
| `ignore_seeds`        | `true`           | Ignores the seeds.                           |
| `ignore_controller`   | `true`           | Ignores the controller.                      |
| `ignore_shared_icon`  | `true`           | Ignores the shared icon.                     |
```

## References

- [strong_migrations](https://github.com/ankane/strong_migrations)
