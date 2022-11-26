cptCup
======

Program that collects BP stats

# Development

## To build Docker Image for development:
- Install Docker Desktop (https://docs.docker.com/desktop/install/mac-install/)
- Make any config updates to Dockerfile if desired
- `docker build -t cpt/cptcup-dev .`
- This will create a local docker image that is referenced in docker-compose
- TODO: Push and host the dev docker image to ECR

## To run application locally using docker
- From root directory run `docker-compose up`. This will run 2 containers. One for the rails webapp, another for postgres
- `docker exec -it cptcup-ruby-container /bin/bash` to log into the rails webapp

### To run the app for the first time
- `docker exec -it cptcup-ruby-container /bin/bash` to log into the rails webapp
- `bundle` to install gems
- `bundle exec rake db:create` to create the dev db
- `bundle exec rake db:migrate` to migrate the db
- `bundle exec rake assets:precompile` to compile the assets. There should be a way where you dont have to do this in development, but not sure...
- `rails s` to start the rails server on port 3000
- `rails c` to start the rails console

### To run the test suite
- `bundle exec rake db:test:prepare`
- `bundle exec rspec`


# Deployment
