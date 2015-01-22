hs.alert("(Re)loading Hammerspoon configuration", 1)

require "terminal"
require "caffeine"
require "window-management"

function reloadConfiguration()
    removeCaffeine()
    cleanupWindowManagement()
    hs.reload()
end

function showDateAndTime()
    hs.alert(os.date("It's %R on %B %e, %G"), 2)
end

--
-- Hotkeys
--

local cmd = {"cmd"}
local mash = {"cmd", "alt", "ctrl"}

hs.hotkey.bind(cmd,  "§", function() toggleTerminal() end)
hs.hotkey.bind(mash, "=", function() toggleCaffeine() end)
hs.hotkey.bind(mash, "c", function() centerFrontMostWindow() end)
hs.hotkey.bind(mash, "m", function() toggleFrontMostWindowMaximized() end)
hs.hotkey.bind(mash, "-", function() showDateAndTime() end)
hs.hotkey.bind(mash, "r", function() reloadConfiguration() end)
