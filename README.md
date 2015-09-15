# clireg
Click registrator

1) run `bundle install`

2) Setup MySQL database: create user `clireg` identified by `secret` grant all privileges on `clireg` database.

3) Run migrations `bundle exec rake db:migrate`

4) `rackup`
