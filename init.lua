hs.alert("(Re)loading Hammerspoon configuration", 1)

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

hs.hotkey.bind({"cmd"}, "§", function()
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

function caffeineClicked()
    setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

if caffeine then
    caffeine:setClickCallback(caffeineClicked)
    setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "=", function()
    caffeineClicked()
end)

--
-- Date and time
--

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "-", function()
    hs.alert(os.date("It's %R on %B %e, %G"), 2)
end)

--
-- Configuration reloading and alerting
--

hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", function()
    caffeine:delete()
    caffeine = nil
    hs.reload()
end):start()
