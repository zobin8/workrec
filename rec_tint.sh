#!/usr/bin/env bash

TINTRC=$HOME/.config/tint2/tint2rc

LOG_PATH="$HOME/Documents/org/workrec.log"
WORK_PATH="$HOME/Programming/script/conktask"
FUN_NAME="FUN Tasks"
WORK_NAME="WORK Tasks"

COLOR_IDLE=0000FF
COLOR_WORKING=FF0000
COLOR_FUN=00FF00

reset()
{
    killall tint2
}

set_status()
{
    sed -i "s/separator_color = .*/separator_color = #$1 80/1" $TINTRC
    sed -i "s/button_text = .*/button_text = $2/1" $TINTRC
    reset
}

get_status()
{
    grep 'separator_color =' $TINTRC | tr 'a-z' 'A-Z' | grep -Eo '[ABCDEF0123456789]{6}'
}

list_combo_menu()
{
    $WORK_PATH -s
    echo "$FUN_NAME"
    echo "$WORK_NAME"
}

get_combo()
{
    list_combo_menu | rofi -dmenu
}

get_options()
{
    awk -F '  -  ' '/^'$1'/{print $2}' $LOG_PATH | sort | uniq | rofi -dmenu
}

run_python()
{
    e="$(echo "$0" | sed 's/rec_tint.*/rec/1')"
    python3 "$e" "$@"
}

set_task()
{
    t="$(get_combo)"
    if [[ $t == $FUN_NAME ]]
    then
        t="$(get_options FUN)"
        f="fun"
        c=$COLOR_FUN
    elif [[ $t == $WORK_NAME ]]
    then
        t="$(get_options WRK)"
        f="work"
        c=$COLOR_WORKING
    else
        f="work"
        c=$COLOR_WORKING
    fi

    t="$(echo $t | sed 's/:.*//g')"
    if [[ -n $t ]]
    then
        set_status "$c" "$t"
        run_python start "$f" "$t"
    else
        reset
    fi
}

set_idle()
{
    set_status $COLOR_IDLE "No work"
    run_python stop
}

status="$(get_status)"
echo "$status"

case "$status" in
    $COLOR_IDLE)
        set_task
        ;;
    $COLOR_WORKING)
        set_idle
        ;;
    $COLOR_FUN)
        set_idle
        ;;
esac
