class HomeController < ActionController::Base
    def index
        if user_signed_in?
            @fullname = current_user.first_name + ' ' + current_user.last_name
        end
    end
end