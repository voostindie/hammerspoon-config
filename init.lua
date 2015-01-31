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
local alt = {"alt"}

hs.hotkey.bind(cmd,  "§", function() toggleTerminal() end)
hs.hotkey.bind(mash, "=", function() toggleCaffeine() end)
hs.hotkey.bind(mash, "-", function() showDateAndTime() end)
hs.hotkey.bind(mash, "r", function() reloadConfiguration() end)

local smallStep = 5
local bigStep = 25

wm = setupWindowManagementModalHotkey({}, "§")

wm:bind({}, "c", function() centerFrontMostWindow(wm) end)
wm:bind({}, "tab", function() centerFrontMostWindow(wm) end)
wm:bind({}, "m", function() toggleFrontMostWindowMaximized(wm) end)

wm:bind({}, "left", function() moveFrontMostWindow(-bigStep, 0) end)
wm:bind({}, "right", function() moveFrontMostWindow(bigStep, 0) end)
wm:bind({}, "up", function() moveFrontMostWindow(0, -bigStep) end)
wm:bind({}, "down", function() moveFrontMostWindow(0, bigStep) end)

wm:bind(alt, "left", function() moveFrontMostWindow(-smallStep, 0) end)
wm:bind(alt, "right", function() moveFrontMostWindow(smallStep, 0) end)
wm:bind(alt, "up", function() moveFrontMostWindow(0, -smallStep) end)
wm:bind(alt, "down", function() moveFrontMostWindow(0, smallStep) end)
