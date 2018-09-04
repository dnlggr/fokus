# Fokus ⌨️

A simple window switcher for tiled windows in macOS.

## What does it do?

_Fokus_ helps you to intuitively switch between windows using customizable keyboard shortcuts.

You can configure shortcuts for switching to the left, right, bottom, and top window, relative to the current active window.

Fokus is not a tiling window manager. All it does is move focus between windows that are already tiled e.g. using [Spectacle](https://github.com/eczarny/spectacle).

## Installation

🌍 Download the [latest release here](https://github.com/dnlggr/Fokus/releases).

Make sure to grant accessibility access to _Fokus.app_ in the Security & Privacy preferences. The app will ask you to do so on startup, if you forget to grant access.

I currently do not have an Apple Developer Program membership. Therefore releases are not code signed. You can run the app by ctrl-clicking it when you first open it.

---

🔧 Of course you can also build the app on your own by cloning this repo and building the app in Xcode. Make sure to run `carthage update` before building.

## Configuration

Keyboard shortcuts can be configured via a dotfile at `~/.fokus`.

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

## Misc.

_Fokus_ is work in progress. The window switching logic is quite rudimentary. Suggestions and improvements via GitHub issues or pull requests are welcome!