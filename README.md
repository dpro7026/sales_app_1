#1. Installation
Create a new Github account
Create a new Cloud9 account
Create a blank workspace on Cloud9
## Setting Up Starter Rails 5 App
Check ruby version (if installed):
```
ruby -v
```
Check rails version (if installed):
```
rails -v
```
Install rails 5:
```
gem install rails 5
```
Check rails version:
```
rails -v
```
Create a new rails app with a Postgresql database:
(rather than default SQLite3 database)
```
rails new first_app --database=postgresql
```
## Adding Devise Gem for User Authentication
Open Gemfile and add devise gem:
```
# For user authentication
gem 'devise', '~> 4.3'
```
Run bundle to install all gems in Gemfile:
```
bundle install
```
Run devise generator (read the instruction output):
```
rails generate devise:install
```
Add the following to config/environments/development.rb:
```
# define default url options for mailer
config.action_mailer.default_url_options = { host: ENV['IP'], port: ENV['PORT'] }
```
Ensure you have root URL defined in config/routes.rb:
(this route is not yet defined)
```
Rails.application.routes.draw do
  root to: "home#index"
end
```
Ensure you have flash message in app/views/layouts/application.html.erb
```
<body>
    <p class="notice"><%= notice %></p>
    <p class="alert"><%= alert %></p>
    <%= yield %>
</body>
```
## Setting Up Postgresql Database
Update development details with a username and host name in config/database.yml:
(the username and host name are environment variables)
```
development:
  <<: *default
  database: sales_app_development
  username: <% ENV['C9_USER'] %> 
  host: <% ENV['IP'] %>
```
Start Postgresql service on the Ubuntu machine:
```
sudo service postgresql start
```
Create a new database calles sales_app_dev:
```
psql -c "create database sales_app_development owner=ubuntu"
```
## Adding Active Admin Gem for Mangaing Admins (requires Devise)
Add activeadmin gem to the Gemfile:
```
# For managing admins
gem 'activeadmin', '~> 1.1'
```
Run bundle install to install new gem in Gemfile:
```
bundle install
```
Run activeadmin generator:
```
rails g active_admin:install
```
Run database migrations (db/migrate/*):
```
rails db:migrate
```
Run database seeds (db/seeds.rb):
```
rails db:seed
```
## Start the App
Run the rails server (using IP and PORT from the enivronment variables):
```
rails s -b $IP -p $PORT
```
Click on 'Share' near top right and copy the link to application URL:
E.g. Mine is: https://davids-workspace-2-davidprovest.c9users.io
It has the form: https://<workspace>-<username>.c9users.io
It will have an error, let's resolve this now.
## Resolving Our Apps First Errors
The error states:
'uninitialized constant HomeController'
### Create a Home Controller
Create a new file called home_controller.rb in app/controllers/ and add the following:
```
class HomeController < ActionController::Base
    def index
        # currently empty
    end
end
```
The error now states:
'HomeController#index is missing a template ...'
### Create an Index View Template
Create a new folder called home in app/views/.
Create a new file called index.html.erb in app/views/home/ and add the following:
```
Hello World!
```
Awesome, no more errors!
##Logging in as Admin User
Create a link on the home page to the admin path.
Add the following to the file app/views/home/index.html.erb:
```
<%= link_to("Admin login", admin_root_path) %>
```
When we seeded the database we added only a single, default admin user. 
Look at the db/seeds.rb file and you can see the email: 'admin@example.com', password: 'password'.
Use these credentials to login as an admin.
## Saving Progrees to GitHub
```
git add .
```
```
git commit -m "<my_first_commit_message>"
```
```
git remote add origin https://github.com/<git_username>/<git_repo_name>.git
```
```
git push -u origin master
```

Well done that is our first checkpoint! 
To summarize we have: 
* Created a cloud workspace (on an Ubunutu OS) 
* Installed Ruby 2.4 and Rails 5+
* Added Devise gem for User Authentication
* Setup Postgresql Database on the workspace
* Added Active Amdmin gem for managing admins (requires Devise gem)
* Started the Rails server (and got errors)
* Resolved our errors (by reading the helpful messages)
* Created our first controller and view
* Logged in as an admin user
* Saved our progress to our GitHub repository 
