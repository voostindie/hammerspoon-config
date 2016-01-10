-- Sets up application shortcuts - Ctrl + <number> - for the top 10 apps
-- Note that the shortcuts only work if the global keyboard shortcuts for
-- selecting a space have been changed, EVEN WHEN DISABLED!
--
-- Ctrl + 0 shows the list of application shortcuts

local apps = {
    "Safari",
    "TextMate",
    "OmniFocus",
    "Reeder",
    "Mail",
    "Keynote",
    "IntelliJ IDEA 15",
    "OmniGraffle",
    "iTunes"
}

local help = ""

-- Set up a hotkey for each app. This breaks if there are more than 9 apps!
for index, name in ipairs(apps) do
    help = help .. "⌃" .. tostring(index) ..  ": " .. name .. "\n"
    hs.hotkey.bind("ctrl", tostring(index), function()
        local app = hs.appfinder.appFromName(name)
        hs.application.launchOrFocus(name)
    end)
end

-- Citrix Viewer (Telewerkportaal) requires a different algorithm to activate:
hs.hotkey.bind("ctrl", "0", function()
    local window = hs.window.get("Telewerkportaal-Shared")
    if window then window:focus() end
end)
help = help .. "⌃0: Citrix Viewer"

hs.hotkey.bind("ctrl", "§", function() hs.alert(help, 4) end)
