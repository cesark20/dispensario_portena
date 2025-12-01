module ApplicationHelper
    def flash_class(level)
        case level.to_sym
            when :notice  then "toast-success"
            when :alert   then "toast-danger"
            when :error   then "toast-danger"
        else "toast-info"
        end
    end
end
