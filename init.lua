hs.alert("(Re)loading Hammerspoon configuration", 1)

require "terminal"
require "caffeine"
require "app-switcher"

function reloadConfiguration()
    removeCaffeine()
    hs.reload()
end

function showDateAndTime()
    hs.alert(os.date("It's %R on %e %B %G"), 2)
end

--
-- Hotkeys
--

local cmd = {"⌘"}
local mash = {"⌘", "⌥", "⌃"}
local alt = {"⌥"}

hs.hotkey.bind(cmd,  "§", toggleTerminal)
hs.hotkey.bind(mash, "=", toggleCaffeine)
hs.hotkey.bind(mash, "-", showDateAndTime)
hs.hotkey.bind(mash, "r", reloadConfiguration)

setupApplicationLauncherModalHotkey({}, "§")
registerApplicationHotkey("a", "Acorn")
registerApplicationHotkey("c", "Citrix Viewer")
registerApplicationHotkey("d", "Dash")
registerApplicationHotkey("e", "Microsoft Excel")
registerApplicationHotkey("f", "ForkLift")
registerApplicationHotkey("g", "OmniGraffle")
registerApplicationHotkey("i", "iA Writer")
registerApplicationHotkey("j", "IntelliJ IDEA")
registerApplicationHotkey("k", "Keynote")
registerApplicationHotkey("l", "OmniOutliner")
registerApplicationHotkey("r", "Reeder")
registerApplicationHotkey("m", "Mail")
registerApplicationHotkey("n", "MindNode")
registerApplicationHotkey("o", "OmniFocus")
registerApplicationHotkey("p", "Microsoft PowerPoint")
registerApplicationHotkey("s", "Safari")
registerApplicationHotkey("t", "TextMate")
registerApplicationHotkey("w", "Rabobank Webmail")
