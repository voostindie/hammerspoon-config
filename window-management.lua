-- No animations please:
hs.window.animationDuration = 0

function centerFrontMostWindow()
    local frontMostWindow = hs.window.focusedWindow()
    if not frontMostWindow then return end
    local windowFrame = frontMostWindow:frame()
    local screenFrame = frontMostWindow:screen():frame()
    windowFrame.x = (screenFrame.w - windowFrame.w) / 2
    windowFrame.y = (screenFrame.h - windowFrame.h) / 2
    frontMostWindow:setFrame(windowFrame)
end

-- When maximizing windows, the old frame is stored in memory so that a
-- second maximize can reset it. Window sizes are kept in memory and not
-- persisted (yet)! If there are 50 maximized windows in memory, all old,
-- no longer existing windows are removed (this hardly ever happens).
-- When reloading the configuration all maximized windows are first reset,
-- because otherwise the original settings are lost.

local maximizedWindows = {}
local maximizedWindowCount = 0

local function purgeMaximizedWindowsIfNeeded()
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

local function maximizeWindow(window)
    maximizedWindows[window:id()] = window:frame()
    window:maximize()
    maximizedWindowCount = maximizedWindowCount + 1
    purgeMaximizedWindowsIfNeeded()
end

local function restoreWindow(window)
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

local function restoreMaximizedWindows()
    for id, frame in pairs(maximizedWindows) do
        local window = hs.window.windowForID(id)
        if window then restoreWindow(window) end
    end
end

function cleanupWindowManagement()
    restoreMaximizedWindows()
    maximizedWindows = nil
    maximizedWindowCount = nil
end
