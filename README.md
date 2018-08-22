# Fokus :left_right_arrow: :arrow_up_down:

A simple window switcher for tiled windows in macOS.

## Installation

Not yet setup.

Currently, you have to download the project and build the app in Xcode to try it out. Make sure to run `carthage update` before building.

Make sure to grant accessibility access to Xcode in the Security & Privacy preferences. The app will ask you to do so on startup, if you forget it.

## Configuration

Hotkeys can be configured via a dotfile at `~/.fokus` which is read at app startup.

### Example

```
# ~/.fokus
#
# possible modifiers are:
# command, control, shift, option

bind command+control+h focus_left
bind command+control+j focus_down
bind command+control+k focus_up
bind command+control+l focus_right
```