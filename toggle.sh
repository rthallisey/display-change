#!/bin/bash

# Set these to your outputs
LAPTOP_MONITOR=LVDS-0
STANDING_MONITOR=VGA-0
SITTING_MONITOR=HDMI-2

XRANDR=$(xrandr)
if [[ -z $XRANDR ]]; then
    echo "Error; is \`xrandr' installed?"
    exit 1
fi

get_state() {
    local output=$1
    local state=$(echo "$XRANDR" | grep $output)

    if [[ $state =~ [0-9]+x[0-9]+ ]]; then
        echo on
    else
        echo off
    fi
}

LAPTOP=$(get_state $LAPTOP_MONITOR)
STANDING=$(get_state $STANDING_MONITOR)
SITTING=$(get_state $SITTING_MONITOR)

echo "Laptop -> $LAPTOP, standing -> $STANDING, sitting -> $SITTING"

if [[ $LAPTOP = "on" && $SITTING = "on" && $STANDING = "off" ]]; then
    # Sitting down and working -> standing up
    xrandr --output $SITTING_MONITOR --off
    xrandr --output $STANDING_MONITOR --primary --auto
    xrandr --output $LAPTOP_MONITOR --off

elif [[ $LAPTOP = "off" && $STANDING = "on" && $SITTING = "off" ]]; then
    # Standing up and working -> sitting down
    xrandr --output $LAPTOP_MONITOR --auto --primary
    xrandr --output $STANDING_MONITOR --off
    xrandr --output $SITTING_MONITOR --right-of $LAPTOP_MONITOR --auto
fi
