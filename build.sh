# rails environment
export RAILS_ENV="test"

# makes bash exit immediately if any command fails
set -e

# makes bash print all of the commands before being executed
set -x

# bundle gems
bundle > /dev/null

# migrate database
bundle exec rake db:migrate > /dev/null

# execute specs
bundle exec rspec spec/business
bundle exec rspec spec/decorators
#bundle exec rspec spec/reports
bundle exec rspec spec/importers
bundle exec rspec spec/helpers
bundle exec rspec spec/lib
bundle exec rspec spec/enumerations
bundle exec rspec spec/models
bundle exec rspec spec/routing
bundle exec rspec spec/controllers
bundle exec rspec spec/views
bundle exec rspec spec/requests
bundle exec rspec spec/mailers
