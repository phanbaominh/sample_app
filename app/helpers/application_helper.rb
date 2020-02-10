module ApplicationHelper
    def full_title(base_title = '')
        base_title.empty? ? "Ruby on Rails Tutorial Sample App"
            : base_title + ' | ' + "Ruby on Rails Tutorial Sample App"
    end
end
