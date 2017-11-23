# 1. Installation
Create a new Github account. https://github.com/<br/>
Create a new Cloud9 account. https://ide.c9.io<br/>
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
Create a new rails app with a Postgresql database:<br/>
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
Ensure you have root URL defined in config/routes.rb:<br/>
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
Update development details with a username and host name in config/database.yml:<br/>
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
Click on 'Share' near top right and copy the link to application URL:<br/>
E.g. Mine is: https://davids-workspace-2-davidprovest.c9users.io<br/>
It has the form: https://`<workspace>`-`<username>`.c9users.io<br/>
It will have an error, let's resolve this now.
## Resolving Our Apps First Errors
The error states:<br/>
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
The error now states:<br/>
'HomeController#index is missing a template ...'
### Create an Index View Template
Create a new folder called home in app/views/.
Create a new file called index.html.erb in app/views/home/ and add the following:
```
Hello World!
```
<strong>Awesome, no more errors!</strong><br/>
##Logging in as Admin User
Create a link on the home page to the admin path.<br/>
Add the following to the file app/views/home/index.html.erb:
```
<%= link_to("Admin login", admin_root_path) %>
```
When we seeded the database we added only a single, default admin user. <br/>
Look at the db/seeds.rb file and you can see the email: 'admin@example.com', password: 'password'.<br/>
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

<strong>Well done that is our first checkpoint!</strong><br/>
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

# 2. Understanding Model-View-Controller (MVC) Architecture
## Adding Users
We add users using Devise generator:
```
rails generate devise User
```
Look at the terminal and all the files that were created.<br/>
They include a new migration file, model file (user.rb) and routes added for users.<br/>
Update the migration file `<timestamp>`_devise_create_users.rb to include firstname and lastname columns:
```
create_table :users do |t|
  ## Adding our own addtional columns to the User table
  t.string :first_name, null: false
  t.string :last_name, null: false
```
Run rails migration (to add the users table to the database):
```
rails db:migrate
```
As Devise added routes for our users, we should locate the sign-up route.<br/>
Look for a URI that says /users/sign_up (it will be a GET request):
```
rails routes
```
Create a link on the home page for users to sign up.<br/>
Add the following to the file app/views/home/index.html.erb:
```
<%= link_to("User Sign Up", new_user_registration_path) %>
```
Create a link on the home page for users to sign in.<br/>
Add the following to the file app/views/home/index.html.erb:
```
<%= link_to("User Sign In", new_user_session_path) %>
```
## Creating a Default User
Add a default user in the db/seeds.rb:
```
User.create!(email: 'harry@example.com', first_name: 'Harry', last_name: 'Potter', password: 'password', password_confirmation: 'password') if Rails.env.development?
```
We cannot run rails db:seed as we have a clash with data already in the database.
`Validation failed: Email has already been taken.`
This is because it is trying to seed the admin user again and the email is already used.<br/>
We will reset the database instead (this will drop and the create fresh databases):
```
rails db:reset
```
At this time the databases will be dropped but fail to re-create.
This is because we have a clash of templates:
`PG::InvalidParameterValue: ERROR:  new encoding (UTF8) is incompatible with the encoding of the template database (SQL_ASCII)`
`HINT:  Use the same encoding as in the template database, or use template0 as template.`
Let's update the template to template0 (as suggested) in config/database.yml:
```
default: &default
  adapter: postgresql
  encoding: unicode
  template: template0
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
```
Now lets create the databases (dev and test):
```
rails db:create
```
## Using Rails Console
Check the user 'Harry Potter' is stored in the database.<br/>
Start the rails console:
```
rails c
```
Then in the rails console search for all users (this does not include admin users):<br/>
You should see 1 user with the details matching the seed details.
```
User.all
```
To check all admins in the database:
```
AdminUser.all
```
Exit the rails console:
```
quit
```
## Update Home Page View
Finally, update the home page to resemble below:<br/>
This is an if statement that will check if a user is signed in (using a method provided by Devise).<br/>
Note we have added a sign out link which you can find the route again using rails routes command.<br/>
The sign out is a button and requires an extra argument of 'method: delete' as it is not a GET request but rather a DELETE request.
```
<% if user_signed_in? %>
    Signed In
    <br />
    <%= button_to('Logout', destroy_user_session_path, method: :delete) %>
<% else %>
    Not Signed In
    <br />
    <%= link_to("Admin login", admin_root_path) %>
    <br />
    <%= link_to("User Sign Up", new_user_registration_path) %>
    <br />
    <%= link_to("User Sign In", new_user_session_path) %>
<% end %>
```
Now we should be able to login as a user with email: 'harry@example.com' and password: 'password'.
The page will show we are logged in and provide a logout button that will should all the other links when we are logged out.
## Accessing User Attributes
Let's give our user a custom weclome message when they are signed in:<br />
We want to say 'Welcome back `<users_full_name>`'.
Begin by updating the home controller located at app/controllers/home_controller.rb,<br />
we want to create a fullname variable in the index action:<br />
Here we have appended (joined) the user's first name with a space followed by their last name.<br />
This concept is known as string concatentation.
```
def index
  @fullname = current_user.first_name + ' ' + current_user.last_name
end
```
Now modifying the app/views/index.html.erb to contain:<br />
Variables (fullname) prepended with an @ symbol are accesible from the accosiated controller.
```
<% if user_signed_in? %>
    Welcome back <%= @fullname %>!
    <br />
    <%= button_to('Logout', destroy_user_session_path, method: :delete) %>
<% else %>
```
## Adding Products using Scaffold
