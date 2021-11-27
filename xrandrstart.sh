
#! /bin/bash
intern=eDP-1
widescreen=DP-3
ultrawidescreen=DP-1

if xrandr | grep "^DP-[0-9] connected"; then
  xrandr --output "$intern" --off --output "$widescreen" --primary --auto --output "$ultrawidescreen" --right-of "$widescreen" --mode 5120x1440
fi

