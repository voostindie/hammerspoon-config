hs.alert("(Re)loading Hammerspoon configuration", 1)

local cmd = {"cmd"}
local mash = {"cmd", "alt", "ctrl"}
--
-- Toggle application visibility
--

function toggleApplication(name)
    local app = hs.appfinder.appFromName(name)
    if not app or app:isHidden() then
        hs.application.launchOrFocus(name)
    else
        app:hide()
    end
end

hs.hotkey.bind(cmd, "§", function()
   toggleApplication("Terminal")
end)

--
-- Caffeinate: prevents the Mac from falling asleep when enabled
--
-- I pulled the icons from here:
-- http://jimmygreen.deviantart.com/art/Retina-Caffeine-menubar-icons-350451587
--

local caffeine = hs.menubar.new()
function setCaffeineDisplay(state)
    local result
    if state then
        caffeine:setIcon("caffeinate-active.png")
    else
        caffeine:setIcon("caffeinate-inactive.png")
    end
    if hs.caffeinate.get("displayIdle") then
        hs.alert("Caffeinate enabled", 1)
    else
        hs.alert("Caffeinate disabled", 1)
    end
end

function toggleCaffeine()
    setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

if caffeine then
    caffeine:setClickCallback(toggleCaffeine)
    setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end

hs.hotkey.bind(mash, "=", function()
    toggleCaffeine()
end)

--
-- Window management
--

hs.window.animationDuration = 0 -- No animations please

function centerFrontMostWindow()
    local frontMostWindow = hs.window.focusedWindow()
    if not frontMostWindow then return end
    local windowFrame = frontMostWindow:frame()
    local screenFrame = frontMostWindow:screen():frame()
    windowFrame.x = (screenFrame.w - windowFrame.w) / 2
    windowFrame.y = (screenFrame.h - windowFrame.h) / 2
    frontMostWindow:setFrame(windowFrame)
end

hs.hotkey.bind(mash, "c", function()
    centerFrontMostWindow()
end)

-- When maximizing windows, the old frame is stored in memory so that a
-- second maximize can reset it. Window sizes are kept in memory and not
-- persisted (yet)! If there are 50 maximized windows in memory, all old,
-- no longer existing windows are removed (this hardly ever happens).
-- When reloading the configuration all maximized windows are first reset,
-- because otherwise the original settings are lost.

local maximizedWindows = {}
local maximizedWindowCount = 0

function purgeMaximizedWindowsIfNeeded()
    if maximizedWindowCount < 50 then return end
    local purgeCount = 0
    for id, frame in pairs(maximizedWindows) do
        local window = hs.window.windowForID(id)
        if not window then
            maximizedWindows[id] = nil
            maximizedWindowCount = maximizedWindowCount - 1
            purgeCount = purgeCount + 1
        end
    end
end

function maximizeWindow(window)
    maximizedWindows[window:id()] = window:frame()
    window:maximize()
    maximizedWindowCount = maximizedWindowCount + 1
    purgeMaximizedWindowsIfNeeded()
end

function restoreWindow(window)
    local id = window:id()
    window:setFrame(maximizedWindows[id])
    maximizedWindows[id] = nil
    maximizedWindowCount = maximizedWindowCount - 1
end

function toggleFrontMostWindowMaximized()
    local frontMostWindow = hs.window.focusedWindow()
    if not frontMostWindow then return end
    if maximizedWindows[frontMostWindow:id()] then
        restoreWindow(frontMostWindow)
    else
        maximizeWindow(frontMostWindow)
    end
end

function restoreMaximizedWindows()
    for id, frame in pairs(maximizedWindows) do
        local window = hs.window.windowForID(id)
        if window then restoreWindow(window) end
    end
end

hs.hotkey.bind(mash, "m", function()
    toggleFrontMostWindowMaximized()
end)

--
-- Date and time
--

hs.hotkey.bind(mash, "-", function()
    hs.alert(os.date("It's %R on %B %e, %G"), 2)
end)

--
-- Configuration reloading and alerting
--

function reloadConfiguration()
    caffeine:delete()
    caffeine = nil
    restoreMaximizedWindows()
    maximizedWindows = nil
    maximizedWindowCount = nil
    hs.reload()
end

hs.hotkey.bind(mash, "r", function()
    reloadConfiguration()
end)


-- hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", function()
--     reloadConfiguration()
-- end):start()
