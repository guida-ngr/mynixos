#!/bin/sh
get_workspaces() {
  swaymsg -t get_workspaces | jq -c '.'
}
get_workspaces
swaymsg -t subscribe '["workspace"]' -m | while read -r _; do
  get_workspaces
done
