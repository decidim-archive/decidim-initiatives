# Decidim::Initiatives

Initiatives is the place on Decidim's where citizens can promote a civic initiative. Unlike
participatory processes that must be created by an administrator, Civic initiatives can be
created by any user of the platform.

An initiative will contain attachments and comments from other users as well.

Prior to be published an initiative must be technically validated. All the validation
process and communication between the platform administrators and the sponsorship 
committee is managed via an administration UI.

## Usage

This plugin provides:

* A CRUD engine to manage initiatives.

* Public views for initiatives via a high level section in the main menu.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'decidim-initiatives'
```

And then execute:
```bash
$ bundle
$ bundle exec rails decidim_initiatives:install:migrations
$ bundle exec rails db:migrate
```

## Seeding test data

## Contributing
See [Decidim](https://github.com/decidim/decidim).

## License
See [Decidim](https://github.com/decidim/decidim).
