class HomeController < ActionController::Base
    def index
        @fullname = current_user.first_name + ' ' + current_user.last_name
    end
end