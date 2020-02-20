function _pure_prompt_sys_time --description "Display system time"
    if test $pure_show_sys_time = true
        set --local time_color (_pure_set_color $pure_color_sys_time)
        echo "$time_color"(date +%T)
    end
end
