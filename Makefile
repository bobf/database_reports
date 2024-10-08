include $(shell bundle exec ruby -e 'require "orchestration/make"')

#
# Example test command
#
# Define your test tasks here. The default command runs RSpec and Rubocop but
# you can feel free to add any other tasks you like.
#
# Set up your test dependencies and run tests by calling: `make setup test`
#
# Subsequent test runs can skip the setup step and simply run: `make test`
#
.PHONY: test
test:
	bundle exec rspec
	bundle exec rubocop
	bundle exec strong_versions

#
# Define any custom setup that needs to take place before running tests.
# If the command exists, it will be called immediately after the `setup`
# command (which starts containers and sets up the database).
#
# This command can be deleted if it is not needed.
#
.PHONY: post-setup
post-setup:
	bundle exec rake db:reports:create
	bundle exec rake db:reports:migrate

#
# Launch all dependencies needed for a development environment and set up the
# development database.
#
.PHONY: develop
develop:
	bundle install
	@$(MAKE) setup env=test
	@$(MAKE) setup env=development
