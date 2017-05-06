# Bacon Cannon =~

https://bacon-cannon.herokuapp.com/

## What's this?

Bacon cannon is an online Ruby parser.
It's support [Ripper](http://ruby-doc.org/stdlib-2.4.0/libdoc/ripper/rdoc/Ripper.html)(Ruby 1.9 ~ 2.4) and [Parser gem](https://github.com/whitequark/parser)(Ruby 1.8 ~ 2.4).



## Developing

Ruby 2.4.1 is required.

1. `git clone git@github.com:pocke/bacon-cannon.git`
1. `git clone git@github.com:pocke/ripper-api.git`
1. `cd ripper-api`
    1. `bundle install`
    1. `bundle exec foreman start`
1. `cd bacon-cannon`
    1. `bundle install`
    1. `bin/rake db:create db:migrate`
    1. `RIPPER24_URL="http://localhost:5000" bin/rails s`
    1. `bin/webpack-dev-server`




## Links

- [pocke/ripper-api](https://github.com/pocke/ripper-api)
