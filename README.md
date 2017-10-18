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

## Database

The database requires the extension pg_trgm enabled. Contact your DBA to enable it.

```sql
CREATE EXTENSION pg_trgm;
```

## Rake tasks

This engine comes with two rake tasks:

### decidim_initiatives:check_validating

This task move all initiatives in validation phase without changes for the amount of 
time defined in __Decidim::Initiatives::max_time_in_validating_state__. These initiatives
will be moved to __discarded__ state.

### decidim_initiatives:check_published

This task retrieves all published initiatives whose support method is online and the support
period has expired. Initiatives that have reached the minimum supports required will pass
to state __accepted__. The initiatives without enough supports will pass to __rejected__ state.

Initiatives with offline support method enabled (pure offline or mixed) will get its status updated
after the presential supports have been registered into the system.

## Seeding example data

In order to populate the database with example data proceed as usual in rails:
```bash
$ bundle exec rails db:seed
```

## Aditional considerations

This engine makes use of cookies to store large form data. You should change the 
default session store or you might experience problems.

## Contributing
See [Decidim](https://github.com/decidim/decidim).

## License
See [Decidim](https://github.com/decidim/decidim).
