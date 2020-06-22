#!/bin/bash

#echo \
#'┌─────┐ '\
#'│     │ '\
#'├┬ ' \
#'└─────┘'
#'┡ '

internal=eDP1
ext=DP3
USBC=DP1

#internal=$(xrandr|grep primary|cut -d' ' -f1)
#ext=$(xrandr |grep ' 'connected| grep -v primary | head -n 1| cut -d' ' -f1)


external_on_top() {
cat <<EOF
┏━━━━┱──┐
┃    ┃  │           External monitor ($ext)
┡━━━━┛  │           on top of interal monitor ($internal)
└───────┘
EOF
}
triple_screen() {
cat <<EOF
 ┏━━━━┓ ┌───────┐ ┏━━━━┓
 ┃    ┃ │       │ ┃    ┃   External monitor ($ext)
 ┗━━━━┛ │       │ ┗━━━━┛   right of interal monitor ($internal)
	└───────┘          Usb-C Left of internal monitor ($internal)
EOF
}
external_right() {
cat <<EOF
┌───────┐ ┏━━━━┓
│       │ ┃    ┃   External monitor ($ext)
│       │ ┗━━━━┛   right of interal monitor ($internal)
└───────┘
EOF
}
external_off() {
cat <<EOF
┌───────┐ ╭┄┄┄┄╮
│       │ ┆    ┆   External monitor ($ext) disabled
│       │ ╰┄┄┄┄╯
└───────┘
EOF
}
internal_off() {
cat <<EOF
╭┄┄┄┄┄┄┄╮ ┏━━━━┓
┆       ┆ ┃    ┃   External monitor ($ext) enabled
┆       ┆ ┗━━━━┛   Internal monitor ($internal) disabled.
╰┄┄┄┄┄┄┄╯
EOF
}

duplicate() {
cat <<EOF
╭┄┄┄┄┄┄┄╮    ┏━━━━┓
┆       ┆ == ┃    ┃   External monitor ($ext) duplicate ($internal).
┆       ┆    ┗━━━━┛   
╰┄┄┄┄┄┄┄╯
EOF
}

print_menu() {
external_off
echo -e '\0'
external_right
echo -e '\0'
triple_screen
echo -e '\0'
external_on_top
echo -e '\0'
internal_off
echo -e '\0'
duplicate
}

update_i3() {
    i3-msg restart
    xset -b
}

disable_screensaver() {
    xset -dpms
    xset s off
}

enable_screensaver() {
    xset +dpms
}

fix_hdmi_audio() {
    if [[ $(< /sys/class/drm/card0/*HDMI*/status) = connected ]] &&
       [[ "$1" != "force-disable" ]] ; then
        # echo "Audio output: HDMI"
        pactl set-card-profile 0 output:hdmi-stereo+input:analog-stereo
    else
        # echo "Audio output: analog"
        pactl set-card-profile 0 output:analog-stereo+input:analog-stereo
    fi
}

element_height=6
element_count=5

res=$(print_menu | rofi \
    -location 0 \
    -dmenu -sep '\0' -lines "$element_count" \
    -eh "$element_height" -p '' -no-custom \
    -format i)

if [ -z "$res" ] ; then
    exit
fi

case "$res" in
    0)
	xrandr --output $ext --off
	xrandr --output $USBC --off
        enable_screensaver
        fix_hdmi_audio force-disable
        ;;
    1)
        xrandr --output $internal --auto --primary --output $ext --auto --right-of $internal
        disable_screensaver
        fix_hdmi_audio
        ;;
    2)
	xrandr --output $USBC --auto --primary    
	xrandr --output $internal --auto --right-of $USBC
	xrandr --output $ext --auto --right-of $internal
	feh --bg-scale "$(< "${HOME}/.cache/wal/wal")"
        disable_screensaver
        fix_hdmi_audio
        ;;
    3)
        xrandr --output $internal --auto --primary --output $ext --auto --pos 0x0
        disable_screensaver
        fix_hdmi_audio
        ;;
    4)
        xrandr --output $ext --auto --output $internal --off
        enable_screensaver
        fix_hdmi_audio
        ;;
    5)  xrandr --output $ext --same-as $internal
        enable_screensaver
        fix_hdmi_audio
        ;;
    *)
        ;;
esac
update_i3

