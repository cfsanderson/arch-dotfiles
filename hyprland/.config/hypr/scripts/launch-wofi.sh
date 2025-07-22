#!/bin/bash

# Terminate any already running wofi instances
killall -q wofi

# Launch a new wofi instance with config
wofi --show drun --sort-order=alphabetical --style=$HOME/.config/wofi/style.css

